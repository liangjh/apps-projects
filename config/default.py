
#  All supported personas
PERSONAS = ['Trump', 'Brexit']

# Trump corpus calibrated markov models - based on (1) speeches, (2) tweets
MARKOV_MODELS = {
    'Trump': [
        {'name': 'model-speech', 'filename': 'trumpspire-model-01.gz', 'max_chars': 200},
        {'name': 'model-tweet',  'filename': 'trumpspire-model-02.gz', 'max_chars': 150}
    ],
    'Brexit': [
        {'name': 'model-tweet-boris', 'filename': 'brexitspire-model-borisjohnson.gz', 'max_chars': 150},
        {'name': 'model-tweet-nigel', 'filename': 'brexitspire-model-nigel_farage.gz', 'max_chars': 150}
    ]
}


TOPIC_PARSE_RULES = [
    #  Named entities at the document level (certain types of named entities allowed)
    #  If the named entity is a single token and is a VERB, the also ignore
    {'type': 'ent',
     'lambda': (lambda ent,nlp: ent.label_ not in ['PERSON', 'NORP', 'DATE',
                        'TIME', 'PERCENT', 'MONEY', 'CARDINAL'] 
                        and not (len(ent.text.split()) <= 1 and nlp(ent.text.lower())[0].pos_ == 'VERB')
                        and not ent.text.startswith('\'') and not ent.text.startswith('\"'))},
    #  Token-based topics, by priority
    #  This constructs tokens according to the rules below.  
    {'type': 'tok', 
     'lambda': (lambda tok,nlp: tok.pos_ in ['NOUN', 'PROPN'] and tok.dep_ in ['ROOT', 'dobj'] 
                        and not tok.text.startswith('\'') and not tok.text.startswith('\"'))},
    {'type': 'tok', 
     'lambda': (lambda tok,nlp: tok.dep_ in ['nsubj', 'nsubjpass'] and tok.pos_ not in ['PRON', 'ADJ' ,'DET'] 
                        and not tok.text.startswith('\'') and not tok.text.startswith('\"'))},
    {'type': 'tok', 
     'lambda': (lambda tok,nlp: tok.pos_ == 'VERB' and tok.dep_ == 'ROOT' 
                        and not tok.text.startswith('\'') and not tok.text.startswith('\"'))}
]

#  Image search / sourcing API - not env specific
PIXABAY_API_KEY='13392888-cce06623972ac1de0f32096a6'

#  Google API credentials, TODO: not an ideal setup here
GOOGLE_API_CREDS_FILE = 'gcs-tspire-creds.json'  

#  For poster construction / creation
POSTER_PARAMS = {
    'Trump': {
        'imgbgrgb': (0,0,0),
        'textrgb': (197,179,88),
        'margin_px': 25,
        'approx_char_px': 15,
        'font_ttf_loc': 'stymie-bold-bt.ttf',
        'font_size_title': 45,
        'font_size_body': 25,
        'base_gap_px': 10,
        'text_start_y_px': 70,
        'text_gap_y_px': 30,
        'final_image_width': 450,
        'signature': '@TrumpSpired',
        'signature_url': '(trumpspired.com)'
    },
    'Brexit': {
        'imgbgrgb': (40,52,147),
        'textrgb': (255,255,255),
        'margin_px': 25,
        'approx_char_px': 15,
        'font_ttf_loc': 'stymie-bold-bt.ttf',
        'font_size_title': 45,
        'font_size_body': 25,
        'base_gap_px': 10,
        'text_start_y_px': 70,
        'text_gap_y_px': 30,
        'final_image_width': 450,
        'signature': '@BrexitSpired',
        'signature_url': '(brexitspired.com)'
    }
}



