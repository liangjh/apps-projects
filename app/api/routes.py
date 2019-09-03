import os
from flask import jsonify, request, current_app, redirect, flash
from werkzeug.utils import secure_filename
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


#  NOTE: this is to allow upload of files to file system
@api.route('/upload', methods=['GET','POST'])
def api_upload():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        
        file = request.files['file']
        # if user does not select file, browser also
        # submit an empty part without filename
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        else:
            filename = secure_filename(file.filename)
            file.save(os.path.join(current_app.config['RAW_UPLOAD_FOLDER'], filename))
    
    return '''
        <!doctype html>
        <title>Upload new File</title>
        <h1>Upload new File</h1>
        <form method=post enctype=multipart/form-data>
        <input type=file name=file>
        <input type=submit value=Upload>
        </form>
    '''


# TODO: enable this for development, otherwise comment out
#   (not sure why this now needs to be sent by the server)
@api.after_request
def apply_cors(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response


