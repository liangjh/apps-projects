
# Data directory (i.e. models, etc) 

RESOURCE_DIRECTORY  = 'resources/'
MODEL_DIRECTORY = 'resources/models/' # this is resource dir within the application

# Persistence method (FS: local file system (default), GCS: google cloud storage_
PERSIST_MEDIUM = 'GCS'  #  FS, or GCS

# Local Persistence Settings
# IMAGE_PERSIST_PROPERTIES = {
    # 'Trump': {
        # 'image_raw_directory': '/Users/liangjh/Workspace/tspire-api/data/images/raw/',
        # 'image_gen_directory': '/Users/liangjh/Workspace/tspire-api/data/images/generated/',
        # 'image_server_base':   'http://localhost:8081/',
        # 'raw_upload_folder':   '/Users/liangjh/Workspace/tspire-api/data/images/raw/'  # legacy - for render.com file system (now defunct)
    # },
    # 'Brexit': {
        # 'image_raw_directory': '/Users/liangjh/Workspace/tspire-api/data/images/raw/',
        # 'image_gen_directory': '/Users/liangjh/Workspace/tspire-api/data/images/generated/',
        # 'image_server_base':   'http://localhost:8081/',
        # 'raw_upload_folder':   '/Users/liangjh/Workspace/tspire-api/data/images/raw/'  # legacy - for render.com file system (now defunct)
    # }
# }

#  GCS Settings 
IMAGE_PERSIST_PROPERTIES = {
    'Trump': {
        'gcs_bucket_name':    'images.trumpspired.com',
        'image_raw_directory': 'raw',
        'image_gen_directory': 'generated',
        # 'image_server_base':   'http://images.trumpspired.com/generated/'
        'image_server_base' :  'https://storage.googleapis.com/images.trumpspired.com/generated/'
    },
    # 'Brexit': {
        # 'gcs_bucket_name':    'images.brexitspired.com',
        # 'image_raw_directory': 'raw',
        # 'image_gen_directory': 'generated',
        # 'image_server_base':   'http://images.brexitspired.com/generated/'
    # }
}

#  Connections, by key
DATABASE_CONNECTIONS = {
    'tspire': {'host': 'dpg-blmma9co8cribb2rmokg', 'port': 5432, 'dbname': 'tspire', 'user': 'tspire', 'password': 'kj7xxb9jOJ'}
}


