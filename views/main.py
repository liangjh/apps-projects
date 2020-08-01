# -*- coding: utf-8 -*-
"""
Assembly views.py
"""
import traceback
import json
import importlib.resources as pkg_resources

from assembly import (Assembly, request, response)

from assembly import config as asmbl_config
from lib.tweemio import twm
import resources as asmbl_resources


#  TODO: for restful endpoint, make screen_name / group part of url (howto?)
#  Primary API endpoint / gateway for tweemio functionality
class Api(Assembly):

  
    @request.cors
    @response.json
    # @response.headers({'Access-Control-Allow-Origin': '*'})
    def user(self):
        '''
        Get user details (+ basic readability scores)
        '''
        screen_name = request.args.get('screen_name')
        force = request.args.get('force') == 'true' 

        if (screen_name is None):
            return generate_api_error('Missing required parameter: screen_name')
        
        try:
            user_details = twm.api_user_details(screen_name, force)
        except Exception as ex:
            user_details = generate_api_error(str(ex))
            print(traceback.print_exc())

        return user_details


    @request.cors
    @response.json
    # @response.headers({'Access-Control-Allow-Origin': '*'})
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
        try:
            results = twm.api_calculate_similarity(screen_name.lower(), group, force)
        except Exception as ex:
            results = generate_api_error(str(ex))
            print(traceback.print_exc())

        return results


    @request.cors 
    @response.json
    # @response.headers({'Access-Control-Allow-Origin': '*'})
    def groupmeta(self):
        '''
        Meta-data for each group;  description, screen names within each group to be evaluated
        '''
        return asmbl_config['SIMILARITY_COMPARISONS']


    @request.cors
    @response.json
    # @response.headers({'Access-Control-Allow-Origin': '*'})
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


