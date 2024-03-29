import typing
import copy
import random
import json
import gzip
import markovify
import spacy
from app.caching import cache
from flask import current_app


class POSifiedText(markovify.Text):
    '''
    POSified text is used for both construction and sentence sythesis
    Includes POS (parts of speech) to allow for more sensible sentence structure.
  '''
    def word_split(self, sentence):
        nlp_model = get_nlp_model('en_core_web_sm')
        return ['::'.join((word.orth_, word.pos_)) for word in nlp_model(sentence)]

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
    print('Generating markov text for persona: {}'.format(persona))

    #  Retreive list fo models applicable
    models = get_models(persona, {k:params[k] for k in ['MODEL_DIRECTORY', 'MARKOV_MODELS', 'PERSONAS']}) 
    model_spec = models[0] # models[random.randint(0, 100) % 2]
    model = model_spec['model']
    text = model.make_short_sentence(max_chars = model_spec['max_chars'])
    print('Markov text ({}): {}'.format(persona, text))
    return text


@cache.memoize()
def get_nlp_model(lang_module='en_core_web_sm'):
    return spacy.load(lang_module)


@cache.memoize()  # Cache decorator; save to memory
def get_models(persona: str='Trump', params: dict={}) -> list:
    '''
    Initializes list of models specified for this persona
    Models are pre-calibrated and saved into json format
    Read into POSifiedText markovify model extension
    
    Params:
        persona: 
        params: 
    '''
    # Initialize all available models specified
    model_specs = copy.deepcopy(params['MARKOV_MODELS'][persona])
    model_dir   = params['MODEL_DIRECTORY']
    
    print('Initializing markov model for persona: {}'.format(persona))
    models = []
    for model_spec in model_specs:
        model_json = read_model_file(model_dir, model_spec['filename'])
        model_obj  = POSifiedText.from_json(model_json)
        model_spec['model'] = model_obj
        models.append(model_spec)

    return models


def read_model_file(model_dir, model_file):
    '''
    The models should be in compressed (zipped) format)
    Additionally, we are reading from within the application
    '''
    model_file_path = '{app_root}/{resource_dir}{model_file}'.format(app_root=current_app.root_path,
                                                                     resource_dir=model_dir, model_file=model_file)
    with gzip.GzipFile(model_file_path, 'r') as fin:
        model_json = json.loads(fin.read().decode('utf-8'))
    
    return model_json


def sentence_topic_extract(text: str, rules: typing.List[typing.Dict], short_circuit: bool=True) -> list:
    '''
    Find the "topic" of a given sentence
    Based on a set of rules (lambda functions), operate on either document-level 
    named entities, or on tokens in the document
    This will inform image search + document title

    Parameters:
      text (str): the sentence / string to search
      rules (list): a list of rules (defined in default.py configuration)
      short_circuit (bool) - if a prioritied match is found, return first matching
    '''
    # TODO: if a named ent is all caps, check that the lower() version is not a verb (i.e. "DO" classified as org)

    nlp = get_nlp_model('en_core_web_sm')
    doc = nlp(text)
    matches = []
    for rule in rules:
        search_elem = [ent for ent in doc.ents] if rule['type'] == 'ent' else [tok for tok in doc]
        curr_matches = [elem for elem in search_elem if rule['lambda'](elem, nlp)]
        matches += curr_matches
        if short_circuit and len(curr_matches) > 0:
            break

    return matches


