import os
import io
import random
import requests
from PIL import Image


PIXABAY_SEARCH_URL = 'https://pixabay.com/api/'

ATTRIB_MAP = {
    'id': 'id',
    'webformatURL': 'url',
    'webformatWidth': 'width',
    'webformatHeight': 'height'
}

def search_images(q: str, api_key: str):
    '''
    Performs a search against the pixabay API
    Returns a list of available images, and key attributes
    (to keep it easier, retrieve attribs and map to internal names)

    Parameters:
        q (str): query string
        api_key (str): API key, as assigned by Pixabay
    '''

    # Only search for photos
    response = requests.get(PIXABAY_SEARCH_URL, 
                    params = {'q': q, 'key': api_key, 'image_type':'photo'})
    results  = response.json().get('hits', [])

    #  Return a subset of resulting attributes
    parsed_results = []
    for res in results:
        parsed_results.append(
                {ATTRIB_MAP[attrib_key]:res[attrib_key] 
                    for attrib_key in ATTRIB_MAP})
    
    return parsed_results


def download_image(result: dict) -> Image:
    '''
    Given result element returned in "search_images", 
    Perform GET request to download image;  return raw image content
    Pre-initialized to PIL Image type object
    '''
    img_content = requests.get(result['url']).content
    return Image.open(io.BytesIO(img_content))


def predl_image_random(image_directory: str) -> Image:
    '''
    Return an image from pre downloaded images 
    (in the event that pixabay api fails or limit reached)
    '''
    
    filenames = os.listdir(image_directory)
    file_rand = filenames[random.randint(0, len(filenames))]
    img = Image.open('{}{}'.format(image_directory, file_rand))
    return img


