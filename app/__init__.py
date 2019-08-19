import os
from flask import Flask
from .api import api

#  Initialize application
app = Flask(__name__)


# --- Load Configurations ---

#  Load base configuration
app.config.from_object('config.default')

#  Load environment-specific configuration
if not os.environ.get('APP_CONFIG_FILE'):
    print('Setting to development')
    os.environ['APP_CONFIG_FILE'] = '../config/development.py'

app.config.from_envvar('APP_CONFIG_FILE')


# --- Register Subdomains / Blueprints ---

app.register_blueprint(api)

if __name__ == '__main__':
    app.run()


