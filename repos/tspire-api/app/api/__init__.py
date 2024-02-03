from flask import Blueprint

api = Blueprint( 'site', __name__, url_prefix='/api')

from . import routes

