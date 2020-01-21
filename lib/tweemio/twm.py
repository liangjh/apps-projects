#  Tweemio: main controller
#  Main controller & production implementation logic
#

import re
import inspect
from lib.tweemio import similarity
from lib.tweemio import twitter

class UserNotFoundException(Exception):
    pass


def calculate(config: dict, screen_name: str, group: str='default', compare_to_screen_names: list=None)-> dict:
    '''
    Given twitter user screen name, calculate similarity to a selection of
    model-calibrated twitter handles.  There is an allowance for multiple "groups" of 
    handles, but we fall back to the default grouping

        [1] download user handle twitter timeline << error check possibility first
            (error checking: (a) does user exist?  , (b) does user have sufficient # of tweets?)
        [2] extract user timeline text, condense to configured condense factor
        [3] vectorize user timeline (using saved countvectorizer) - i.e. last “x” tweets, whatever fits into single request
        [4] pass timeline through each calibrated model (for each personality)
        [5] for each, calc *average* (+ stdev) similarity score + get top 10 most similar tweets
        [6] save summary results to JSON to persistence location or google bucket
        [7] save top-line results into database table

    Parameters:
        config: assembly config object (dict-like); allows for run in notebook, etc
    '''

    if (compare_to_screen_names is None):
        compare_to_screen_names = config['SIMILARITY_COMPARISONS'][group]['screen_names']

    twitter_creds = config['TWITTER_API_CREDS']
    tapi = twitter.TwitterApi(twitter_creds)
    
    if (not tapi.user_exists(screen_name)): 
        raise UserNotFoundException(f'User: {screen_name} not found or does not exist in twitter')

    #  Download user timeline;  condense / merge tweets, based on condense factor 
    print(f'Downloading user timeline for: {screen_name}')
    tweet_timeline = tapi.timeline(screen_name, condense_factor=config['TWEET_CONDENSE_FACTOR'])

    #  Get model implementation group
    similarity_model_fn_name = config['SIMILARITY_COMPARISONS'][group]['similarity_function'] 
    similarity_model = dict(inspect.getmembers(similarity, inspect.isfunction))[similarity_model_fn_name]
    
    #  Evaluate similarity to all in group
    similarity_analysis = {}
    for screen_name in compare_to_screen_names:
        print(f'Evaluating similarity to {screen_name} with model: {similarity_model_fn_name}');
        similarity_analysis[screen_name] = similarity_model(group, screen_name, tweet_timeline)
    
    return similarity_analysis



