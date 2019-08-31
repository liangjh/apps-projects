from flask import jsonify, request, current_app
from . import api
from app.spire import inspire


@api.route('/generate')
def api_generate():
    '''
    This goes through and generates a full implementation
    '''
    persona = request.args.get('persona')
    persona = 'Trump' if persona is None else persona
    
    results = inspire.inspire_generate(persona, current_app.config)
    return jsonify(results)


@api.route('/recents')
def api_recents():
    '''
    Most recent generated values 
    '''

    persona = request.args.get('persona')
    persona = 'Trump' if persona is None else persona
    
    results = inspire.inspire_latest(persona, current_app.config)
    return jsonify(results) 


@api.route('/search')
def api_search():
    '''
    This is just a roundtrip test
    '''
    persona = request.args.get('persona')
    persona = 'Trump' if persona is None else persona
    q = request.args.get('q')

    results = inspire.inspire_search(persona, q, current_app.config)
    return jsonify(results)


# TODO: enable this for development, otherwise comment out
#   (not sure why this now needs to be sent by the server)
@api.after_request
def apply_cors(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response


