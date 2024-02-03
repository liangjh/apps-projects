import os
from flask import Flask
from .api import api


#  Initialize flask app / server
app = Flask(__name__)

#  Load blueprints
app.register_blueprint(api)

#  Enviroment initialization
#  Pass variable "FLASK_ENV", or will assume development
envobj = {
    'development':  'config.development',
    'staging':      'config.staging',
    'production':   'config.production'
}[os.environ.get('FLASK_ENV', 'development')]

print('Application root located at: {}'.format(app.root_path))
print('Loading environments: {}'.format(', '.join(['config.default', envobj])))
app.config.from_object('config.default')
app.config.from_object(envobj)



