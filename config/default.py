
#  All supported personas
PERSONAS = ['Trump']

# Trump corpus calibrated markov models - based on (1) speeches, (2) tweets
MARKOV_MODELS = {
    'Trump': [
        {'name': 'model-speech', 'filename': 'trumpspire-model-01.json', 'max_chars': 200},
        {'name': 'model-tweet',  'filename': 'trumpspire-model-02.json', 'max_chars': 150}
    ]
}



