
#  All supported personas
PERSONAS = ['Trump']

# Trump corpus calibrated markov models - based on (1) speeches, (2) tweets
MARKOV_MODELS = {
    'Trump': [
        {'name': 'model-speech', 'filename': 'trumpspire-model-01.json', 'max_chars': 200},
        {'name': 'model-tweet',  'filename': 'trumpspire-model-02.json', 'max_chars': 150}
    ]
}


TOPIC_PARSE_RULES = [
    #  Named entities at the document level (certain types of named entities allowed)
    #  If the named entity is a single token and is a VERB, the also ignore
    {'type': 'ent',
     'lambda': (lambda ent,nlp: ent.label_ not in ['PERSON', 'NORP', 'DATE',
                        'TIME', 'PERCENT', 'MONEY', 'CARDINAL'] and not
                        (len(ent.text.split()) <= 1 and nlp(ent.text.lower())[0].pos_ == 'VERB'))},
    #  Token-based topics, by priority
    #  This constructs tokens according to the rules below.  
    {'type': 'tok', 'lambda': (lambda tok,nlp: tok.pos_ in ['NOUN', 'PROPN'] and tok.dep_ == 'ROOT')},
    {'type': 'tok', 'lambda': (lambda tok,nlp: tok.pos_ in ['NOUN', 'PROPN'] and tok.dep_ == 'dobj')},
    {'type': 'tok', 'lambda': (lambda tok,nlp: tok.dep_ in ['nsubj', 'nsubjpass'] and tok.pos_ != 'PRON')},
    {'type': 'tok', 'lambda': (lambda tok,nlp: tok.pos_ == 'VERB' and tok.dep_ == 'ROOT')}
]

#  Image search / sourcing API - not env specific
PIXABAY_API_KEY='13392888-cce06623972ac1de0f32096a6'

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
    }
}



