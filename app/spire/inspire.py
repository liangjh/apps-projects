'''
Inspire, entry point
Main controller for inspire generation
'''
import random
from . import spiremodel
from app.images import pixabay, poster
from app.db import tspire as db_tspire
from caching import cache


def inspire(persona: str='Trump', config: dict={}) -> dict:
    '''
    Main controller
    Generates an inspirational quotes, constructs an inspirational "poster"
    Saves images and returns a direct link to saved image
    (+ other actions, as necessary)
    '''

    # Retrieve markov model(s)
    # Generate sensible quote (alt. between the two models)
    text = spiremodel.markov_generate(persona, config)
    topics = spiremodel.sentence_topic_extract(text, config['TOPIC_PARSE_RULES'])
    title = topics[0] if len(topics) > 0 else None

    # TODO: pixabay dynamic search may not be needed
    # Retrieve image using unsplash integration
    # Use existing image library (i.e. alt between dynamic search and general inspire)
    img = pixabay.predl_image_random(config['IMAGE_DIRECTORY'])
    if title is None:
        img_results = pixabay.search_images(title, config['PIXABAY_API_KEY'])
        if len(img_results) > 0:
            img = pixabay.download_image(img_results[random.randint(0, len(img_results))])

    # Generate poster image, save to location
    persisted_info = poster.make_poster(img, config['POSTER_PARAMS'][persona],
                                        config['DATA_DIRECTORY'], title=title.upper(), quote=text)
    # Persist quote (+ image link) to persistent storage
    db_tspire.tspire_save(guid=persisted_info['guid'], persona=persona,
                          img_file_lg=persisted_info['img_file_lg'], img_file_sm=persisted_info['img_file_sm'],
                          title=title, text=text)
    
    # Usage logging  (if exists)
    # Return image locations + metadata (in dict)
    return persisted_info


@cache.memoize
def inspire_latest(persona: str) -> list:
    '''
    Return the latest spires to be generated, for the current persona
    '''
    latest = db_tspire.tspire_latest(persona)
    return latest.to_dict('records')


