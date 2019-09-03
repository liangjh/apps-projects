'''
Functionality to read / write images 
Images are stored either locally, or on a cloud infrastructure (google cloud)
Methodology of retrieval will be different
'''
import random
import os
import io
import uuid
from google.cloud import storage
from PIL import Image
from flask import current_app
from app.caching import cache


PERSIST_MEDIUM = ['FS', 'GCS']


@cache.memoize()
def image_list(persist_medium: str, image_persist_properties: dict={}):
    '''
    Given the storage medium, get list of available raw images
    Either in local directory, or in google cloud storage
    Cache to allow for fast(er) access going forward
    '''
    print('Retrieving image list')
    if (persist_medium == 'GCS'):
        client = gcs_client()
        bucket = client.get_bucket(image_persist_properties['gcs_bucket_name'])
        raw_imgfiles = [imgfile.name for imgfile in bucket.list_blobs() if imgfile.name.startswith('{}/'.format(image_persist_properties['image_raw_directory']))]
        return raw_imgfiles

    if (persist_medium == 'FS'):
        filelist = os.listdir(image_persist_properties['image_raw_directory'])
        return filelist

    return []


@cache.memoize()
def gcs_client():
    '''
    Initializes GCS client, from system properties / variables  
    '''
    print('Initializing GCS client')
    creds_file_path = '{app_root}/{resource_dir}{creds_file}'.format(app_root=current_app.root_path,
                                                    resource_dir=current_app.config['RESOURCE_DIRECTORY'], 
                                                    creds_file=current_app.config['GOOGLE_API_CREDS_FILE'])

    # client = storage.Client()  # for setting env property GOOGLE_APPLICATION_CREDENTIALS
    client = storage.Client.from_service_account_json(creds_file_path)
    return client


def predl_image_random(persist_medium: str, image_persist_properties: dict={}):

    filenames = image_list(persist_medium, image_persist_properties)
    filename  = filenames[random.randint(0, len(filenames) - 1)]

    print('Retrieving random image: {}, from source: {}'.format(filename, persist_medium))
    if (persist_medium == 'GCS'):
        client = gcs_client()
        bucket = client.get_bucket(image_persist_properties['gcs_bucket_name'])
        blob = bucket.get_blob(filename)
        img_bytes = blob.download_as_string()
        image = Image.open(io.BytesIO(img_bytes)) 
        return image

    image = Image.open('{}{}'.format(image_persist_properties['image_raw_directory'], filename))
    return image


def save_image(image: Image, persist_medium: str, image_persist_properties: dict={}):
    '''
    Saves a completed image to GCS or to a file system path
    '''
    
    #  Save GUID value
    guid = uuid.uuid4().hex
    img_file = '{}.jpg'.format(guid)

    print('Saving image: {}, to medium: {}'.format(img_file, persist_medium))
    if (persist_medium == 'GCS'):
        client = gcs_client()
        bucket = client.get_bucket(image_persist_properties['gcs_bucket_name'])
        byte_io = io.BytesIO()
        image.save(byte_io, 'jpeg', optimize=True, quality=35)  # save to byte stream; this will get uploaded
        filepath = '{}/{}'.format(image_persist_properties['image_gen_directory'], img_file)
        bucket.blob(filepath).upload_from_string(byte_io.getvalue())
    
    else:
        #  Save to file system
        image.save('{}{}'.format(image_persist_properties['image_gen_directory'], img_file), 
                    optimize=True, quality=35)
    
    return {
        'guid': guid,
        'img_file': img_file,
    }





