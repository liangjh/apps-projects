import copy
import random
import json
import markovify
import spacy
from app.caching import cache

#nlp = spacy.load('en_core_web_sm')


class POSifiedText(markovify.Text):
    '''
    POSified text is used for both construction and sentence sythesis
    Includes POS (parts of speech) to allow for more sensible sentence structure.
  '''

    def word_split(self, sentence):
        return ['::'.join((word.orth_, word.pos_)) for word in nlp(sentence)]

    def word_join(self, words):
        sentence = ' '.join(word.split('::')[0] for word in words)
        return sentence


def markov_generate(persona: str='Trump', params: dict={}) -> str:
    '''
    Generate a quote from initialized markov models
    Models have already been calibrated; this auto-generates something from 
    the Markov model and returns.

    Parameters:
    - persona
    - params  
    '''
    check_valid_persona(persona, params)
    print('Generating markov text for persona: {}'.format(persona))

    #  Retreive list fo models applicable
    models = get_models(persona, {k:params[k] for k in ['MODEL_DIRECTORY', 'MARKOV_MODELS', 'PERSONAS']}) 
    model_spec = models[random.randint(0, 100) % 2]
    model = model_spec['model']
    text = model.make_short_sentence(max_chars = model_spec['max_chars'])
    print('Markov text ({}): {}'.format(persona, text))
    return text
    

@cache.memoize  # Cache decorator; save to memory
def get_models(persona: str='Trump', params: dict={}) -> list:
    '''
    Initializes list of models specified for this persona
    Models are pre-calibrated and saved into json format
    Read into POSifiedText markovify model extension
    
    Params:
        persona: 
        params: 
    '''
    check_valid_persona(persona, params)
    
    # Initialize all available models specified
    model_dir   = params['MODEL_DIRECTORY']
    model_specs = copy.deepcopy(params['MARKOV_MODELS'][persona])

    print('Initializing markov model for persona: {}'.format(persona))
    models = []
    for model_spec in model_specs:
        model_file = model_spec['filename']
        with open('{}{}'.format(model_dir, model_file)) as json_file:
            model_json = json.load(json_file)
        model_obj  = POSifiedText.from_json(model_json)
        model_spec['model'] = model_obj
        models.append(model_spec)

    return models


def check_valid_persona(persona: str, params: dict):
    '''
    Checks that the persona is valid 
    (i.e. exists in the list of supported personas)
    '''
    if (persona == None or persona not in params['PERSONAS']):
        raise Exception('Persona: {} is not supported.  '.format(persona))

