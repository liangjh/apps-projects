#  Tweemio: main controller
#  Main controller & production implementation logic
#

import re
from lib.tweemio import twm
from assembly import config as asmbl_config


class UserNotFoundException(Exception):
    pass


def calculate(screen_name: str, group: str='default') -> dict:
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
    '''

    
    twitter_creds = asmbl_config.TWITTER_API_CREDS
    tapi = twm.TwitterApi(twitter_creds)
    
    if (not tapi.user_exists(screen_name)): 
        raise UserNotFoundException(f'User: {screen_name} not found or does not exist in twitter')

    #  Download user timeline;  condense / merge tweets, based on settings
    tweet_timeline = tapi.timeline(screen_name)
    timeline_text = list(reversed([tli._json['full_text'] for tli in tweet_timeline])) 
    timeline_text = condense_timeline(timeline_text, condense_factor=asmbl_config.TWEET_CONDENSE_FACTOR)
    

    #  Get all users associated with group
    screen_names = asmbl_config.TWITTER_HANDLES_GROUPS[group]
    similarity_scores = {screen_names : similarity_model() for screen_name in screen_names}


    return None



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

