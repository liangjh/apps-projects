import numpy as np
import inspect
from lib.tweemio import similarity
from lib.tweemio import twitter


class UserNotFoundException(Exception):
    pass


def calculate(config: dict, screen_name: str, group: str='trumpian')-> dict:
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
        config: application configuration (dict-like object)
        screen_name: twitter handle to compare
        group: group of twitter handles to compare to
    Returns:
        dict of screen_names (in group to compare to), along with comparison metrics
    '''

    tapi = twitter.TwitterApi(config['TWITTER_API_CREDS'])
    if (not tapi.user_exists(screen_name)): 
        raise UserNotFoundException(f'User: {screen_name} not found or does not exist in twitter')

    #  Download user timeline;  condense / merge tweets, based on condense factor 
    tweet_timeline = tapi.timeline(screen_name, condense_factor=config['TWEET_CONDENSE_FACTOR'])

    #  User complexity scores
    user_complexity_scores = similarity.mdl_readability_scores(tweet_timeline)

    #  Get similarity model implementation group
    similarity_model_fn_name = config['SIMILARITY_COMPARISONS'][group]['similarity_function'] 
    similarity_model_fn = dict(inspect.getmembers(similarity, inspect.isfunction))[similarity_model_fn_name]
    
    #  Evaluate similarity to all members of group (each member has a calibrated model)
    similarity_analysis = {}
    compare_to_screen_names = config['SIMILARITY_COMPARISONS'][group]['screen_names']
    for screen_name in compare_to_screen_names:
        similarity_analysis[screen_name] = similarity_model_fn(group, screen_name, tweet_timeline)
   
    #  -- Post Processing / Results Formatting --
    #  Extract average similarity score per reference personality
    #  Extract top / most similar tweets for each reference personality (>= 75% similarity)
    similarity_results = {}
    for screen_name, similarity_df in similarity_analysis.items():
        avg_score = np.mean(similarity_df.y_prob)
        top_df = similarity_df[similarity_df.y_prob >= 0.75].sort_values('y_prob', ascending=False)
        top_similar = top_df.iloc[:3, :]
        similarity_results[screen_name] = {
                    'avg_similarity_score': avg_score,
                    'top_similar': top_similar.to_dict('records')
                }
    
    return {
        'complexity_score': user_complexity_scores,
        'similarity': similarity_results
    }

