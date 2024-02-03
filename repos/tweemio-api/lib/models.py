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

import uuid
import datetime

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


    def should_refresh(self, days_refresh:int=20):
        '''
        Compare latest download time w/ refresh floor
        '''
        last_update = self.updated_at.date()
        days_since  = (datetime.date.today() - last_update).days
        recalc = days_since > days_refresh
        return recalc


    @property
    def timeline(self):
        ''' Get linked timeline object '''
        data = filepersist.read_json(asmbl_config['PERSISTENCE'], 
                                     self.assemble_filename_tline(self.screen_name,  self.created_at, self.uuid))
        return data


    @property
    def readability(self):
        ''' Get linked readability object '''
        rdbl = filepersist.read_json(asmbl_config['PERSISTENCE'], 
                                     self.assemble_filename_readbl(self.screen_name, self.created_at, self.uuid)) 
        return rdbl


    @classmethod
    def latest(cls, screen_name: str):
        '''
        Get latest calc (if exists)
        '''
        #  TODO: don't get all, get last in sql perhaps
        records = list(cls.query().filter(
                        (cls.screen_name == screen_name))\
                    .order_by(cls.created_at.desc()))
        record = records[0] if (records != None and len(records) > 0) else None
        return record


    @classmethod
    def persist(cls, screen_name: str, name: str, desc: str, profile_img: str, 
                readability: dict, data: dict):
        '''
        Save calc (db) + calc resul(file to persistence location)
        Delete prior calc (if exists), create a new calca
        '''
        #  Delete prior calc
        tline = cls.latest(screen_name)
        if (tline != None): 
            tline.delete() 

        #  Create new calc; and persist results (timeline, readability score) 
        guid = uuid.uuid4().hex
        record = cls.create(screen_name=screen_name, uuid=guid, name=name, desc=desc, profile_img=profile_img)
        filepersist.save_json(asmbl_config['PERSISTENCE'], cls.assemble_filename_tline(screen_name, record.created_at, guid), data)
        filepersist.save_json(asmbl_config['PERSISTENCE'], cls.assemble_filename_readbl(screen_name, record.created_at, guid), readability)

        return guid


    @classmethod
    def assemble_filename_tline(cls, screen_name: str, tdate: datetime.date, guid: str) -> str:
        return f"{tdate.strftime('%Y%m%d')}__tl__{screen_name}__{guid}.json"

    @classmethod
    def assemble_filename_readbl(cls, screen_name:str, tdate: datetime.date, guid: str) -> str:
        return f"{tdate.strftime('%Y%m%d')}__rd__{screen_name}__{guid}.json"




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
    

    @property
    def calc_data(self):
        ''' Get linked calc results '''
        data = filepersist.read_json(asmbl_config['PERSISTENCE'], 
                                     self.assemble_filename_calc(self.screen_name, self.grp, self.created_at, self.uuid))
        return data


    @classmethod
    def latest(cls, screen_name: str, grp: str):
        '''
        Get latest calc (if exists)
        '''
        records = list(cls.query().filter(
                (cls.grp == grp) & (cls.screen_name == screen_name)).order_by(cls.created_at.desc()))
        record = records[0] if (records != None and len(records) > 0) else None
        return record


    @classmethod
    def persist(cls, screen_name: str, grp: str, data:dict):
        '''
        Delete prior calc (if exists), create a new calc
        '''
        user_calc = cls.latest(screen_name, grp)
        if (user_calc != None): 
            user_calc.delete() 

        #  Create new calc; and persist results
        guid = uuid.uuid4().hex
        record = cls.create(screen_name=screen_name, grp=grp, uuid=guid)
        filepersist.save_json(asmbl_config['PERSISTENCE'], cls.assemble_filename_calc(screen_name, grp, record.created_at, record.uuid), data)
        return guid


    @classmethod 
    def assemble_filename_calc(cls, screen_name: str, grp: str, tdate: datetime.date, guid: str) -> str:
        return f"{tdate.strftime('%Y%m%d')}__cl__{screen_name}__{grp}__{guid}.json"



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



