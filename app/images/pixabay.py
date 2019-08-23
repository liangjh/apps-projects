import requests
import uuid
import PIL


PIXABAY_SEARCH_URL = 'https://pixabay.com/api/'


def search_images(q: str, api_key: str, attrib:str=None):
    '''
    Performs a search against the pixabay API
    Returns a list of available images

    Parameters:
        q (str): query string
        api_key (str): API key, as assigned by Pixabay
        attrib (str): attrib to retrieve, if passed (or will return all)
    '''

    response = requests.get(PIXABAY_SEARCH_URL, params = {'q': q, 'key': api_key})
    results  = response.json().get('hits', [])
    if attrib != None:
        results = [res[attrib] for res in results]

    return results


def download_image(url_location: str, params: dict={}, 
        file_extension: str='jpg', optimize: bool=True) -> tuple:
    '''
    Given a URL, download object, and save result to file system
    w/ generated UUID. Returns a tuple (UUID, filepath)
    Expects property "IMAGE_DIRECTORY" to be initialized

    Parameters:
        url_location
        params: 
        file_extension;
    '''
    #  File name (+ guid)
    image_directory = params['IMAGE_DIRECTORY']
    guid = uuid.uuid4().hex
    filename = '{}{}.{}'.format(image_directory, guid, file_extension)

    # Download & save file to name/location
    # Use PIL library to optimize size / reduce quality
    img_data = requests.get(url_location).content
    with open(filename, 'w') as handler:
        handler.write(img_data)

    #  Optimization, greatly reduces image size w/o noticeable quality change
    if optimize:
        img = PIL.Image.open(filename)
        img.save(filename, optimize=True, quality=60)

    return (guid, filename)

