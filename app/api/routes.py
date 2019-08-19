from flask import jsonify
import random
from . import api

# TODO: this is only temporary
TMP_SPIRES = [
        {'text': 'I grab and grab','image': {'small': 'http://localhost:8080/static/im-001.jpeg', 'large': 'http://localhost:8080/static/im-001.jpeg'}},
        {'text': "How do you do that , we gave them Iraq .", 'image': {'small': "http://localhost:8080/static/im-001.jpeg"}},
        {'text': "You ’ve got to do it , of our religion , of our tremendous security burden .", 'image': {'small': "http://localhost:8080/static/im-002.jpeg"}},
        {'text': "Now , they ’re all saying , you know , the dreams of children .", 'image': {'small': "http://localhost:8080/static/im-003.jpeg"}},
        {'text': "I grew up in Brooklyn , I ventured into Manhattan and did a lot of these guys just got two .", 'image': {'small': "http://localhost:8080/static/im-004.jpeg"}},
        {'text': "We ’re going to protect her .", 'image': {'small': "http://localhost:8080/static/im-005.jpeg"}}, 
        {'text': "You know , just at the end of it .", 'image': {'small': "http://localhost:8080/static/im-006.jpeg"}},
        {'text': "Even our own FBI director has admitted that we can not afford to talk around the issue anymore -- we have people .", 'image': {'small': "http://localhost:8080/static/im-007.jpeg"}},
        {'text': "The heroine is pouring in and they ’ll be happy .", 'image': {'small': "http://localhost:8080/static/im-008.jpeg"}},
        {'text': "And remember this ; we are only going to have to rebuild quickly our infrastructure of this country again .", 'image': {'small': "http://localhost:8080/static/im-009.jpeg"}},
        {'text': "I guess I just heard about it .", 'image': {'small': "http://localhost:8080/static/im-010.jpeg"}},
        {'text': "The Fed is even considering yet another boring book based on thin air .", 'image': {'small': "http://localhost:8080/static/im-011.jpeg"}},
        {'text': "Just because your still upset over an election in 2020 .", 'image': {'small': "http://localhost:8080/static/im-012.jpeg"}},
        {'text': "Bill prohibits local Gov’t from enacting Sanctuary policies that protect undocumented immigrants ... @FoxNews", 'image': {'small': "http://localhost:8080/static/im-013.jpeg"}},
        {'text': "Today , it ’s time to bring new hope to many families during the Obama years .", 'image': {'small': "http://localhost:8080/static/im-014.jpeg"}}
    ]



@api.route('/test')
def api_search():
    '''
    This is just a roundtrip test
    '''
    return jsonify({'abc':1, 'xyz':2, 'ijk':3})


@api.route('/generate')
def api_generate():
    '''
    This goes through and generates a full implementation
    '''
    # TODO: move this into an actual implementation module
    
    result = TMP_SPIRES[random.randint(0, len(TMP_SPIRES) - 1)]
     
    return jsonify(result)


@api.route('/recents')
def api_recents():
    '''
    Most recent generated values 
    '''
    # TODO: 

    return jsonify(TMP_SPIRES)



