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

from assembly import db

# ------------------------------------------------------------------------------

class Test(db.Model):
    name = db.Column(db.String(255), index=True)


# ----- MODELS FOR TWEEMIO -----


'''
twm_user_calc
  - screen_name (string)
  - group (string)
  - uuid (string)
    ( + calc time will be created_at)
    pk: screen_name, uuid, created_at

twm_sn_model
  - screen_name (string)
  - version (int)
  - active (bool) 
  - group (string)
  - pytype (string)  # instantiate using reflection
  - pckl (blob/binary): binary object (
    pk: screen_name, version, active

twm_model_group
  - group
  - name
  - desc
    pk: group
'''

class TwmUserCalc(db.Model):
    '''
    Each time a person requests a calculation, a UUID is generated which stores
    the model's calculation results
    '''
    screen_name = db.Column(db.String(255))
    grp  = db.Column(db.String(100))
    uuid = db.Column(db.String(200))


class TwmSnModel(db.Model):
    '''
    Stores the screen name model binary
    Model binary is a pickle of the respective scikit-learn model
    '''
    screen_name = db.Column(db.String(255))
    version  = db.Column(db.Integer)
    active   = db.Column(db.Boolean)
    grp      = db.Column(db.String(100))
    pckl     = db.Column(db.PickleType)





