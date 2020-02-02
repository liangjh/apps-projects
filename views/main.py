# -*- coding: utf-8 -*-
"""
Assembly views.py
"""
import json
import importlib.resources as pkg_resources

from assembly import (Assembly,
                      date,
                      request,
                      response,
                      HTTPError)

from assembly import config as asmbl_config
from lib.tweemio import twm
import resources as asmbl_resources

# ------------------------------------------------------------------------------


#  Primary API endpoint / gateway for tweemio functionality
class Api(Assembly):

    @request.cors
    @response.json
    def calculate(self):
        '''
        Performs similarity calculation for a given screen_name against a tweem.io preconfigured group
        '''

        screen_name = request.args.get('screen_name')
        group = request.args.get('group')
        force = request.args.get('force') == 'true'

        # Basic error / parameter checking
        if (screen_name is None or group is None):
            return generate_api_error('Missing one or more required parameters: screen_name, group')
        group_set = list(asmbl_config['SIMILARITY_COMPARISONS'].keys())
        if (group not in group_set):
            return generate_api_error(f'Group must be one of the following: {group_set}')

        # Invoke calculation gateway and return
        results = twm.calculate(asmbl_config, screen_name, group, force)
        return results


    @request.cors
    @response.json
    def groupmeta(self):
        '''
        Meta-data for each group;  description, screen names within each group to be evaluated
        '''
        return asmbl_config['SIMILARITY_COMPARISONS']


    @request.cors
    @response.json
    def screenmeta(self):
        '''
        Meta-data for each screen name in sysstem
        '''
        screen_meta_txt  = pkg_resources.read_text(asmbl_resources, 'model_user_profiles.json')
        screen_meta_json = json.loads(screen_meta_txt)
        return screen_meta_json


def generate_api_error(msg: str):
    return {
        'error': True,
        'message': msg
    }


#  --------------------  Testing / Evaluation ---------------------------

class Index(Assembly):

    def index(self):
        return

    @request.cors
    @response.json
    def api(self):
        return {
            "date": date.utcnow(),
            "description": "API Endpoint with CORS and JSON response"
        }

    @response.json
    @response.cache(timeout=10)
    def cached(self):
        return {
            "description": "This is a cached endpoint",
            "date": date.utcnow(),
        }


    def error(self):
        """
        Accessing /error should trigger the error handlers below
        """
        raise HTTPError.NotFound()
