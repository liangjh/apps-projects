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
    # Retrieve image using unsplash integration
    # Use existing image library (i.e. alt between dynamic search and general inspire)
    img = pixabay.predl_image_random(config['IMAGE_RAW_DIRECTORY'])
    if title is not None:
        img_results = pixabay.search_images(title, config['PIXABAY_API_KEY'])
        if len(img_results) > 0:
            img = pixabay.download_image(img_results[random.randint(0, len(img_results))])

    # Generate poster image, save to location
    poster_img = poster.make_poster(img, config['POSTER_PARAMS'][persona], config['DATA_DIRECTORY'], 
                                    title=(title.upper() if title is not None else title), quote=text)

    # Save image + information
    persisted_info = poster.save_poster(poster_img, save_path=config['IMAGE_GEN_DIRECTORY'])
    db_tspire.tspire_save(guid=persisted_info['guid'], persona=persona,
                          img_file_lg=persisted_info['img_file_lg'], img_file_sm=persisted_info['img_file_sm'],
                          title=title, text=text)
    
    # Usage logging  (if exists)
    # Return image locations + metadata (in dict)
    persisted_info = image_full_path(persisted_info, config['IMAGE_SERVER_BASE'])
    addl_info = {'persona': persona, 'title': title, 'text': text}
    return {**persisted_info, **addl_info}



@cache.memoize
def inspire_latest(persona: str, config: dict={}) -> list:
    '''
    Return the latest spires to be generated, for the current persona
    '''
    latest = db_tspire.tspire_latest(persona)
    results = latest.to_dict('records')
    results = [image_full_path(res, config['IMAGE_SERVER_BASE']) for res in results]
    return results


def image_full_path(result: dict, serverbase: int):
    
    result['img_file_lg'] = '{}{}'.format(serverbase, result['img_file_lg'])
    result['img_file_sm'] = '{}{}'.format(serverbase, result['img_file_sm'])
    return result


