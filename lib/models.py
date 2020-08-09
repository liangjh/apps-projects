# -*- coding: utf-8 -*-
"""
Assembly: models.py

*This module is loading implicitely by Assembly. Do not import*
Contains applications models and other databases connections.
To setup: `asm gen:sync-models`

## Example 

class MyModel(db.Model):
    name = db.Column(db.String(255), index=True)

## Usage

from assembly import models
Accessor: models.[ClassName]
ie: models.MyModel
-----
"""

import uuid as gen_uuid
import datetime
import json

from assembly import db
from assembly import config as asmbl_config
from lib.tweemio import filepersist
from lib.caching import cache

# ----- MODELS FOR TWEEMIO -----


class TwmUserTimeline(db.Model):
    '''
    User profile information
    User readability score (from timeline)
    Reference to user timeline file
    '''
    screen_name = db.Column(db.String(255))
    uuid = db.Column(db.String(200))
    name = db.Column(db.String(255))
    desc = db.Column(db.String(512))
    profile_img = db.Column(db.String(512))
    readability_js = db.Column(db.Text())

    def should_refresh(self, days_refresh:int=20):
        '''
        Compare latest download time w/ refresh floor
        '''
        last_update = self.updated_at.date()
        days_since  = (datetime.date.today() - last_update).days
        recalc = days_since > days_refresh
        return recalc

    @property
    def readability(self):
        return json.loads(self.readability_js)

    @classmethod
    def latest(cls, screen_name: str):
        '''
        Get latest calc (if exists)
        '''
        user_tlines = list(cls.query().filter(
                (cls.screen_name == screen_name))\
                    .order_by(cls.created_at.desc()))
        user_tline = user_tlines[0] if (user_tlines != None and len(user_tlines) > 0) else None
        if user_tline is None:
            return (None, None)

        data = filepersist.read_json(asmbl_config['PERSISTENCE'],
                              filepersist.assemble_filename_tline(screen_name, user_tline.uuid))
        return (user_tline, data)


    @classmethod
    def persist(cls, screen_name: str, name: str, desc: str, profile_img: str, 
                    readability: dict, data: dict):
        '''
        Save calc (db) + calc resul(file to persistence location)
        Delete prior calc (if exists), create a new calca
        '''
        #  Delete prior calc
        tline, tline_data = cls.latest(screen_name)
        if (tline != None): 
            tline.delete() 

        #  Create new calc; and persist results
        guid = gen_uuid.uuid4().hex
        filepersist.save_json(asmbl_config['PERSISTENCE'],
                              filepersist.assemble_filename_tline(screen_name, guid), data)
        cls.create(screen_name=screen_name, uuid=guid, name=name, desc=desc, profile_img=profile_img,
                   readability_js=json.dumps(readability))
        return guid


class TwmUserCalc(db.Model):
    '''
    Each time a person requests a calculation, a UUID is generated which stores
    the model's calculation results
    '''
    screen_name = db.Column(db.String(255))
    grp  = db.Column(db.String(100))
    uuid = db.Column(db.String(200))


    def should_refresh(self, days_refresh:int=20):
        '''
        Compare latest download time w/ refresh floor
        '''
        last_update = self.updated_at.date()
        days_since  = (datetime.date.today() - last_update).days
        recalc = days_since > days_refresh
        return recalc

    @classmethod
    def latest(cls, screen_name: str, grp: str):
        '''
        Get latest calc (if exists)
        '''
        user_calcs = list(cls.query().filter(
                (cls.grp == grp) & (cls.screen_name == screen_name)).order_by(cls.created_at.desc()))
        user_calc = user_calcs[0] if (user_calcs != None and len(user_calcs) > 0) else None
        if user_calc is None:
            return (user_calc, None)
        
        data = filepersist.read_json(asmbl_config['PERSISTENCE'],
                              filepersist.assemble_filename_calc(screen_name, grp, user_calc.uuid))
        return (user_calc, data)


    @classmethod
    def persist(cls, screen_name: str, grp: str, data:dict):
        '''
        Delete prior calc (if exists), create a new calc
        '''
        user_calc, calc_data = cls.latest(screen_name, grp)
        if (user_calc != None): 
            user_calc.delete() 

        #  Create new calc; and persist results
        guid = gen_uuid.uuid4().hex
        filepersist.save_json(asmbl_config['PERSISTENCE'],
                              filepersist.assemble_filename_calc(screen_name, grp, guid), data)
        cls.create(screen_name=screen_name, grp=grp, uuid=guid)
        return guid



class TwmSnModel(db.Model):
    '''
    Stores the screen name model binary
    Model binary is a pickle of the respective scikit-learn model
    '''
    model_name  = db.Column(db.String(255))
    version     = db.Column(db.Integer)
    active      = db.Column(db.Boolean)
    grp         = db.Column(db.String(100))
    pckl        = db.Column(db.PickleType)

    @classmethod
    @cache.memoize()
    def get_model(cls, grp: str, model_name: str):
        '''
        Retrieves the appropriate calibrated model for a given "group"
        Each screen name has a particular model of concern
        '''
        #  There should be a single *active* row per model name
        #  TODO: perhaps move queries like this to model object?
        model_rows = list(cls.query().filter(
                            (cls.grp == grp) & \
                            (cls.model_name == model_name) & \
                            (cls.active == True)))

        #  If DNE, will break (its okay)
        model_obj = model_rows[0].pckl
        return model_obj



