import os
from flask import Flask
from .api import api


#  Initialize flask app / server
app = Flask(__name__)

#  Load environment variables 
app.config.from_object('config.default')
app.config.from_object('config.development')

#  Load blueprints
app.register_blueprint(api)

#  Enviroment initialization
envobj = {
    'development': 'config.development',
    'staging': 'config.staging',
    'production': 'config.production'
}[os.environ.get('FLASK_ENV', 'development')]

print('Loading environments: {}'.format(', '.join(['config.default', envobj])))
app.config.from_object('config.default')
app.config.from_object(envobj)



#  TODO: toggle environment to load

