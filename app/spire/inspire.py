'''
Inspire, entry point
Main controller for inspire generation
'''
import random
from . import spiremodel
from app.images import pixabay, poster
from app.db import tspire as db_tspire
from app.caching import cache


def inspire_generate(persona: str='Trump', config: dict={}) -> dict:
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
    title = topics[0].text if len(topics) > 0 else None

    # TODO: pixabay dynamic search may not be needed
    # Retrieve image using pixabay API integration
    # Otherwise, use existing image library (i.e. alt between dynamic search and general inspire)
    img = pixabay.predl_image_random(config['IMAGE_RAW_DIRECTORY'])
    if title is not None:
        img_results = pixabay.search_images(title, config['PIXABAY_API_KEY'])
        if len(img_results) > 0:
            img = pixabay.download_image(img_results[random.randint(0, len(img_results)-1)])

    # Generate poster image, save to location
    poster_img = poster.make_poster(img, config['POSTER_PARAMS'][persona], config['RESOURCE_DIRECTORY'], 
                                    title=(title.upper() if title is not None else title), quote=text)

    # Save image + information
    persisted_info = poster.save_poster(poster_img, save_path=config['IMAGE_GEN_DIRECTORY'])
    db_tspire.tspire_save(guid=persisted_info['guid'], persona=persona, img_file=persisted_info['img_file'],
                          title=title, text=text)
    
    # Usage logging  (if exists)
    # Return image locations + metadata (in dict)
    persisted_info['img_file']  = '{}{}'.format(config['IMAGE_SERVER_BASE'], persisted_info['img_file'])
    addl_info = {'persona': persona, 'title': title, 'text': text}
    return {**persisted_info, **addl_info}


@cache.memoize(ttl_sec=10800)  # 3 hrs
def inspire_latest(persona: str, config: dict={}) -> list:
    '''
    Return the latest spires to be generated, for the current persona
    '''
    latest = db_tspire.tspire_latest(persona)
    results = latest.to_dict('records')
    for res in results:
        res['img_file'] = '{}{}'.format(config['IMAGE_SERVER_BASE'], res['img_file'])
    return results


def inspire_search(persona: str, q: str, config: dict={}) -> list:
    '''
    Performs full-text search on all spires generated for a given persona
    (db object takes care of this)

    Parameters
        persona: 
        q: search string
        config: environment configuration
    '''

    #  Nothing worth searching;  return blank
    if (q is None or len(q.split()) < 1):
        return []
    
    search_results = db_tspire.tspire_search(persona, q)
    results = search_results.to_dict('records')
    for res in results:
        res['img_file'] = '{}{}'.format(config['IMAGE_SERVER_BASE'], res['img_file'])
    return results


