'''
Inspire, entry point
Main controller for inspire generation
'''
from . import spiremodel


def inspire(persona: str='Trump', config: dict={}) -> dict:
    '''
    Main controller
    Generates an inspirational quotes, constructs an inspirational "poster"
    Saves images and returns a direct link to saved image
    (+ other actions, as necessary)
    '''
    #  TODO: think multi-tenancy, if needed in the future

    # Retrieve markov model(s)
    # Generate sensible quote (alt. between the two models)
    text = spiremodel.markov_generate(persona, config)
    
    # Retrieve image using unsplash integration
    # Use existing image library (i.e. alt between dynamic search and general inspire)
    # Draw quote over image (medium, small)
    # Image size optimization
    # Save images to data location
    # Persist quote (+ image link) to persistent storage
    # Usage logging  (if exists)
    # Return image locations + metadata (in dict)
    
    return text





