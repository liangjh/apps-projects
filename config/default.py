
#  All supported personas
PERSONAS = ['Trump']

# Trump corpus calibrated markov models - based on (1) speeches, (2) tweets
MARKOV_MODELS = {
    'Trump': [
        {'name': 'model-speech', 'filename': 'trumpspire-model-01.json', 'max_chars': 200},
        {'name': 'model-tweet',  'filename': 'trumpspire-model-02.json', 'max_chars': 150}
    ]
}

#  Name entities on the doc (spans tokens)
#  Allow entities that are not in the below
TOPIC_PARSE_DOC_ENT_LAMBDAS = [
    (lambda ent: ent.label_ not in ['PERSON', 'NORP', 'EVENT', 'DATE',
            'LAW', 'DATE', 'TIME', 'PERCENT', 'MONEY', 'CARDINAL'])
]

#  Token-based topics, by priority
#  This constructs tokens according to the rules below.  
TOPIC_PARSE_DOC_TOK_LAMBDAS = [
    (lambda tok: tok.pos_ == 'NOUN' and tok.dep_ == 'ROOT'),
    (lambda tok: tok.pos_ == 'NOUN' and tok.dep_ == 'dobj'),
    (lambda tok: tok.dep_ in ['nsubj', 'nsubjpass'] and tok.pos_ != 'PRON')
]




