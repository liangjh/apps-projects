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
    Performs search (full text) on all generated spires for a given persona
    '''
    persona = request.args.get('persona')
    persona = 'Trump' if persona is None else persona
    q = request.args.get('q')

    results = inspire.inspire_search(persona, q, current_app.config)
    return jsonify(results)


#  Allow access from any domain / subdomain
@api.after_request
def apply_cors(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response


