#  Tweemio: main controller
#  Main controller & production implementation logic
#

import re
import inspect
from lib.tweemio import similarity
from lib.tweemio import twitter

class UserNotFoundException(Exception):
    pass


def calculate(config: dict, screen_name: str, group: str='default', compare_to_screen_names: list=None) -> dict:
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

    twitter_creds = config['TWITTER_API_CREDS']
    tapi = twitter.TwitterApi(twitter_creds)
    
    if (not tapi.user_exists(screen_name)): 
        raise UserNotFoundException(f'User: {screen_name} not found or does not exist in twitter')

    #  Download user timeline;  condense / merge tweets, based on settings
    print(f'Downloading user timeline for: {screen_name}')
    tweet_timeline = tapi.timeline(screen_name)
    timeline_text = list(reversed([tli._json['full_text'] for tli in tweet_timeline])) 
    timeline_text = condense_timeline(timeline_text, condense_factor=config['TWEET_CONDENSE_FACTOR'])

    #  Get all users associated with group
    #  Unless an explicit group is passed in 
    if (compare_to_screen_names is None):
        compare_to_screen_names = config['SIMILARITY_COMPARISONS'][group]['screen_names']

    #  Get model implementation group
    similarity_model_fn_name = config['SIMILARITY_COMPARISONS'][group]['similarity_function'] 
    similarity_model = dict(inspect.getmembers(similarity, inspect.isfunction))[similarity_model_fn_name]
    
    #  Evaluate similarity to all in group
    similarity_analysis = {}
    for screen_name in compare_to_screen_names:
        print(f'Evaluating similarity to {screen_name} with model: {similarity_model_fn_name}');
        similarity_analysis[screen_name] = similarity_model(group, screen_name, timeline_text) 
    
    return similarity_analysis


#  Remove non-parseable patterns ** adjustable **
def condense_timeline(timeline_text: list, filter_regex: str='^(http)', condense_factor: int=1) -> list:
    '''
    Constructs timeline text based on filter regex as well as condense factor
    (i.e. number of tweets to compress together)
    '''
    timeline_text = [' '.join([('' if (re.search(filter_regex, word) != None) else word) for word in text.split()]) for text in timeline_text]
    timeline_text = [t for t in timeline_text if len(t.strip()) > 0]

    #  Group by condense factor (i.e. grouping multiple tweets into single tweet)
    timeline_text = [
        ' '.join(timeline_group) for timeline_group in 
        zip(*[timeline_text[n::condense_factor] for n in range(0, condense_factor)])
    ]
    
    return timeline_text

