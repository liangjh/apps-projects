
# Data directory (i.e. models, etc) 

RESOURCE_DIRECTORY  = 'resources/'
MODEL_DIRECTORY = 'resources/models/' # this is resource dir within the application

# Persistence method (FS: local file system (default), GCS: google cloud storage_
# PERSIST_MEDIUM = 'GCS'  #  FS, or GCS
PERSIST_MEDIUM = 'FS'

# Local Persistence Settings
IMAGE_PERSIST_PROPERTIES = {
    'Trump': {
        'image_raw_directory': '/Users/liangjh/Workspace/tspire-api/data/images/raw/',
        'image_gen_directory': '/Users/liangjh/Workspace/tspire-api/data/images/generated/',
        'image_server_base':   'http://localhost:8081/',
        'raw_upload_folder':   '/Users/liangjh/Workspace/tspire-api/data/images/raw/'  # legacy - for render.com file system (now defunct)
    },
    'Brexit': {
        'image_raw_directory': '/Users/liangjh/Workspace/tspire-api/data/images/raw/',
        'image_gen_directory': '/Users/liangjh/Workspace/tspire-api/data/images/generated/',
        'image_server_base':   'http://localhost:8081/',
        'raw_upload_folder':   '/Users/liangjh/Workspace/tspire-api/data/images/raw/'  # legacy - for render.com file system (now defunct)
    }
}

#  GCS Settings 
# IMAGE_PERSIST_PROPERTIES = {
    # 'Trump': {
        # 'gcs_bucket_name':    'images-dev.trumpspired.com',
        # 'image_raw_directory': 'raw',
        # 'image_gen_directory': 'generated',
        # 'image_server_base':   'http://images-dev.trumpspired.com/generated/'
    # },
    # 'Brexit': {
        # 'gcs_bucket_name':    'images-dev.brexitspired.com',
        # 'image_raw_directory': 'raw',
        # 'image_gen_directory': 'generated',
        # 'image_server_base':   'http://images-dev.brexitspired.com/generated/'
    # }
# }

#  Connections, by key
DATABASE_CONNECTIONS = {
    'tspire': {'host': 'localhost', 'port': 5432, 'dbname': 'tspire', 'user': 'tspire', 'password': 'MAGA'}  # local postgres database
}


