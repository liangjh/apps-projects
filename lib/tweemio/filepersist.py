import json
from google.cloud import storage
from google.oauth2 import service_account
import importlib.resources as pkg_resources

from lib.caching import cache
import resources

#
#  Simple file persistence to either local or google cloud services
#  Use same creds as tspire account, for central management
#  We are only reading/saving JSON files (text content), so no need to handle binary, etc
#  If need arises, can expand to handle larger file type set
#

@cache.memoize()
def gcs_client():
    '''
    Initialize GCS from local credentials file (assumed to be in same directory as package)
    '''
    
    creds_txt  = pkg_resources.read_text(resources, 'gcs-creds.json')
    creds_info = json.loads(creds_txt)

    credentials = service_account.Credentials.from_service_account_info(creds_info)
    storage_client = storage.Client(creds_info['account_id'], credentials=credentials)
    return storage_client


def save_json(config: dict, filename: str, contents):
    '''
    Saves text/json file to gcs or local
    '''
    print(f"Saving to [{config['methodology']}]: {filename}")
    if config['methodology'] == 'gcs':
        client = gcs_client()
        bucket = client.get_bucket(config['root'])
        filepath = f"{config['datadir']}/{filename}"
        blob = bucket.get_blob(filepath)
        blob.upload_from_string(json.dumps(contents), content_type='text/json')
    else:
        filepath = f"{config['root']}/{config['datadir']}/{filename}"
        with open(filepath, 'w+') as fl:
            json.dump(contents, fl)


def read_json(config: dict, filename: str) -> dict:
    '''
    Reads text/json file from gcs or local
    Returns dict representing json
    '''
    data = {}
    if config['methodology'] == 'gcs':
        client = gcs_client()
        bucket = client.get_bucket(config['root'])
        filepath = f"{config['datadir']}/{filename}"
        content_s = bucket.get_blob(filepath).download_as_string()
        data = json.loads(content_s)
    else:
        filepath = f"{config['root']}/{config['datadir']}/{filename}"
        with open(filepath, 'r') as fl:
            data = json.load(fl)

    return data



