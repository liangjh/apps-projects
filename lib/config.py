# -*- coding: utf-8 -*-
"""
Assembly: config.py

*This module is loading implicitely by Assembly. Do not import*

Class based config file, where each class is an environment:
ie: Dev = Development, Production=Production, ...

Global config shared by all applications

The method allow multiple configuration

By default, it is expecting the Dev and Prod, but you can add your class
which extends from BaseConfig

- Access in templates
You have the ability to access these config in your template
just use the global variable `config`
ie:
    {{ config.APPLICATION_NAME }}

"""

import os
from pathlib import Path

# Root directory
ROOT_DIR = Path(__file__).parent.parent

# Data directory
DATA_DIR = os.path.join(ROOT_DIR, "data")


class BaseConfig(object):
    """
    Base configuration

    """

    #: Site's name or Name of the application
    APPLICATION_NAME = "Tweemio"
    #: The application url
    APPLICATION_URL = ""
    #: Version of application
    APPLICATION_VERSION = "0.0.1"
    #: Google Analytics ID
    GOOGLE_ANALYTICS_ID = ""
    #: Required to setup. This email will have SUPER USER role
    ADMIN_EMAIL = None
    #: The address to receive email when using the contact page
    CONTACT_EMAIL = None
    # To remove whitespace off the HTML result
    COMPRESS_HTML = False
    # Data directory
    DATA_DIR = DATA_DIR

    #------------------- DATE FORMAT and TIMEZONE -------------
    # Arrow is used as date parser
    # from assembly import date
    # http://crsmithdev.com/arrow
    # To view tokens: http://crsmithdev.com/arrow/#tokens

    # Timezone to use when dealing with date. 
    # Example
    # date.now().to(config.get("TIMEZONE"))
    # Timezone
    TIMEZONE = "US/Eastern"

    # Date format
    # Dict of dates format
    # Example
    # date.now().format(config.get("DATE_FORMAT.default"))
    DATE_FORMAT = {
        "default": "MM/DD/YYYY",
        "date": "MM/DD/YYYY",
        "datetime": "MM/DD/YYYY hh:mm a",
        "time": "hh:mm a",
        "long_datetime": "dddd, MMMM D, YYYY hh:mm a",
    }
    
    # -------- API (Twitter) ----------

    TWITTER_API_CREDS = {
        'consumer_key':        'wbz78wFd0ywcShiTvqgDUV2ry',
        'consumer_secret':     '2qj0P3fygqa0n2LqU6M8LV485OWIAvXWEQOEVLWFNUBdKDcgjz',
        'access_token_key':    '80578720-t7bH4zwD6Q6sUQEFeCb8211wH04Y9ul0EWECo2ofU',
        'access_token_secret': 'PSsX8R4agpxAII9XCYHqE74KObPRWfl9tdG4Xd07olOn6'
    }

    # ------- APPLICATION SETTINGS ------

    #  Groups of screen_names and similarity model to apply to each group
    SIMILARITY_COMPARISONS = {
        'trumpian': {
            'name': 'Trumpism Elite',
            'screen_names': [
                'realdonaldtrump', 'kellyannepolls', 'secpompeo', 'mike_pence', 'devinnunes', 'lindseygrahamsc',
                'donaldjtrumpjr', 'rudygiuliani', 'govmikehuckabee', 'alandersh', 'repmattgaetz', 'jim_jordan',
                'markmeadows', 'gopleader', 'senatemajldr', 'betsydevosed', 'elisestefanik', 'seanhannity', 
                'gopchairwoman', 'charliekirk11', 'kayleighmcenany', 'parscale', 'seanspicer', 'sarahhuckabee', 
                'dancrenshawtx', 'jasonmillerindc', 'kanyewest', 'sentedcruz'
            ],
            'similarity_function': 'mdl_multinomialnbvect_v1' #  function in module: lib.tweemio.similarity
        },
        'antitrump': {
            'name': 'Prominent Resistance',
            'screen_names': [
                'gtconway3d', 'steveschmidtses', 'jwgop', 'therickwilson', 'nhjennifer', 'ronsteslow', 'reedgalen', 
                'madrid_mike', 'donwinslow', 'scaramucci', 'justinamash', 'kasparov63', 'danrather', 'stephenking',
                'hamillhimself', 'georgetakei', 'preetbharara', 'sarahcpr'
            ],
            'similarity_function': 'mdl_multinomialnbvect_v1' #  function in module: lib.tweemio.similarity
        },
        'prominentdems': {
            'name': 'Prominent Democrats',
            'screen_names': [
                'andrewyang', 'kamalaharris', 'petebuttigieg', 'joebiden', 'ewarren', 'berniesanders', 'corybooker',
                'amyklobuchar', 'juliancastro', 'aoc', 'reptedlieu', 'harrisonjaime', 'davidaxelrod', 'drbiden', 
                'michelleobama', 'barackobama', 'chrismurphyct', 'andrewyang', 'betoorourke'
            ],
            'similarity_function': 'mdl_multinomialnbvect_v1' #  function in module: lib.tweemio.similarity
        },
        'techbiz': {
            'name': 'Tech / Business',
            'screen_names': [
                'elonmusk', 'billgates', 'sundarpichai', 'tim_cook', 'jeffbezos', 'karaswisher', 'mcuban', 'guykawasaki', 
                'jeffweiner', 'guyraz',  'richardbranson', 'jack', 'mikebloomberg', 'richardbranson',
                'ariannahuff', 'tferriss', 'reidhoffman', 'sophiaamoruso', 'patflynn', 'barbaracorcoran', 
            ],
            'similarity_function': 'mdl_multinomialnbvect_v1' #  function in module: lib.tweemio.similarity
        },
        'culturalicons': {
            'name': 'Culture / Entertainment',
            'screen_names': [
                'chrissyteigen', 'pink', 'britneyspears', 'mindykaling', 'katyperry', 
                'ladygaga', 'brunomars', 'johnlegend',
                'billmaher', 'conanobrien', 'jimmyfallon', 'jimmykimmel', 'trevornoah', 'jimgaffigan',
                'sarahksilverman', 'stevemartintogo', 'stephenathome', 'jerryseinfeld',
                'sethmeyers', 'fullfrontalsamb'
            ],
            'similarity_function': 'mdl_multinomialnbvect_v1' #  function in module: lib.tweemio.similarity
        },

   }

    #  Tweets to merge into a single tweet, for model training and interpretation
    TWEET_CONDENSE_FACTOR = 3

    #  Days between when similarity scores can be recomputed
    SIMILARITY_DAYS_RECALC = 30


    #--------- DATABASES URL ----------

    #: DB_URL
    #: Assembly uses Active-Alchemy to work with DB 
    #: format: engine://USERNAME:PASSWORD@HOST:PORT/DB_NAME
    #: format: dialect+driver://USERNAME:PASSWORD@HOST:PORT/DB_NAME
    #: SQLite: sqlite:////foo.db
    #: SQLite in memory: sqlite://
    #: Postgresql: postgresql+pg8000://user:password@host:port/dbname
    #: MySQL: mysql+pymysql://user:password@host:port/dbname
    DB_URL = "sqlite:////%s/db.sqlite" % DATA_DIR

    #: DB_REDIS_URL
    #: format: USERNAME:PASSWORD@HOST:PORT
    DB_REDIS_URL = None


    #--------- STORAGE ----------
    #: STORAGE
    #: Flask-Cloudy is used to save upload on S3, Google Storage,
    #: Cloudfiles, Azure Blobs, and Local storage
    #: When using local storage, they can be accessed via http://yoursite/files
    #:
    STORAGE = {
        #: STORAGE_PROVIDER:
        # The provider to use. By default it's 'LOCAL'.
        # You can use:
        # LOCAL, S3, GOOGLE_STORAGE, AZURE_BLOBS, CLOUDFILES
        # "PROVIDER": "LOCAL",
        "PROVIDER": None,

        #: STORAGE_KEY
        # The storage key. Leave it blank if PROVIDER is LOCAL
        "KEY": None,

        #: STORAGE_SECRET
        #: The storage secret key. Leave it blank if PROVIDER is LOCAL
        "SECRET": None,

        #: STORAGE_REGION_NAME
        #: The region for the storage. Leave it blank if PROVIDER is LOCAL
        "REGION_NAME": None,

        #: STORAGE_CONTAINER
        #: The Bucket name (for S3, Google storage, Azure, cloudfile)
        #: or the directory name (LOCAL) to access
        "CONTAINER": DATA_DIR, #os.path.join(DATA_DIR, "uploads"),

        #: STORAGE_SERVER
        #: Bool, to serve local file
        "SERVER": True,

        #: STORAGE_SERVER_URL
        #: The url suffix for local storage
        "SERVER_URL": "files",

        #:STORAGE_UPLOAD_FILE_PROPS
        #: A convenient K/V properties for storage.upload to use when using `upload_file()`
        #: It contains common properties that can passed into the upload function
        #: ie: upload_file("profile-image", file)
        "UPLOAD_FILE_PROPS": {
            # To upload regular images
            "image": {
                "extensions": ["jpg", "png", "gif", "jpeg"],
                "public": True
            },

            # To upload profile image
            "profile-image": {
                "prefix": "profile-image/",
                "extensions": ["jpg", "png", "gif", "jpeg"],
                "public": True
            }
        }

    }

    #--------- CACHING ----------
    #: Flask-Cache is used to caching
    CACHE = {
        #: CACHE_TYPE
        #: The type of cache to use
        #: null, simple, redis, filesystem,        
        "TYPE": "simple",

        #: CACHE_REDIS_URL
        #: If CHACHE_TYPE is 'redis', set the redis uri
        #: redis://username:password@host:port/db        
        "REDIS_URL": "",

        #: CACHE_DIR
        #: Directory to store cache if CACHE_TYPE is filesystem, it will
        "DIR": ""
    }

    #--------- LOGIN_MANAGER ----------
    # Flask-Login login_manager configuration
    LOGIN_MANAGER = {
        #: The name of the view to redirect to when the user needs to log in.
        #: (This can be an absolute URL as well, if your authentication
        #: machinery is external to your application.)
        "login_view": None,

        #: The message to flash when a user is redirected to the login page.
        "login_message": "Please log in to access this page.",

        #: The message category to flash when a user is redirected to the login page.
        "login_message_category": "message",

        #: The name of the view to redirect to when the user needs to reauthenticate.
        "refresh_view": None,

        #: The message to flash when a user is redirected to the 'needs
        #: refresh' page.
        "needs_refresh_message": "Please reauthenticate to access this page.",

        #: The message category to flash when a user is redirected to the
        #: 'needs refresh' page.
        "needs_refresh_message_category": "message",
    }
 

# -------------------------- ENVIRONMENT BASED CONFIG ---------------------------
"""
The environment based config is what will be loaded.
By default it will load the development

## 1. Set environment variables
export ASSEMBLY_ENV=Development # for development
export ASSEMBLY_APP=default  

## 2. Run the wsgi
wsgi:app


### **for development server
asm gen:serve

"""

class Development(BaseConfig):
    """ Config for development environment """
    SERVER_NAME = None
    DEBUG = True
    SECRET_KEY = "PLEASE CHANGE ME"

    #: DB_URL
    #: Assembly uses Active-Alchemy to work with DB 
    #: Postgresql: postgresql+pg8000://user:password@host:port/dbname
    #  DB_URL = "sqlite:////%s/db.sqlite" % DATA_DIR
    DB_URL = "postgresql+pg8000://tspire:sa1lb0at@localhost:5432/tspire"

    # Persistence Method
    # For saving / reading User Data
    PERSISTENCE = {
        'methodology': 'local',   # gcs or local (default)
        'root': '/Users/liangjh/workspace/tweemio-api/data',
        'datadir': 'userdata'
    }


class Production(BaseConfig):
    """ Config for Production environment """
    SERVER_NAME = None
    DEBUG = False
    SECRET_KEY = "whatisthis"
    COMPRESS_HTML = True

    # Database in production
    DB_URL = 'postgresql://tspire:kj7xxb9jOJ@dpg-blmma9co8cribb2rmokg:5432/tspire'
 
    #  (for remote connectivity)
    # DB_URL = 'postgres://tspire:kj7xxb9jOJ@oregon-postgres.render.com/tspire'

    # For saving / caching calculated user similarity scores
    PERSISTENCE = {
        'methodology': 'gcs',
        'root': 'images.tweem.io',  
        'datadir': 'userdata'
    }


