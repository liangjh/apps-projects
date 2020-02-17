import datetime
import inspect
import numpy as np
from lib.tweemio import similarity
from lib.tweemio import twitter

from assembly import models as asmbl_models
from assembly import config as asmbl_config


class UserNotFoundException(Exception):
    pass



def calculate(screen_name: str, group: str='trumpian', force: bool=False) -> dict:
    '''
    Gateway function to similarity score calculation
    Check if user has calculated using this group within last N days (N = analysis barrier)
    If so, then pull latest results from persistent store location (gcs or local)
    If no, recalculate;  Persist results ref to database, store to persistence location (gcs or local)

    Parameters:
        config: application configuration dict
        screen_name: twitter handle being evaluated
        group: tweem.io group to evaluate similarities on
        force: force a model re-evaluation
    '''

    #  Get latest tline data, if exists
    #  Download user timeline (if needed) + persist
    user_tline, tline_data = asmbl_models.TwmUserTimeline.latest(screen_name)
    if (force or user_tline is None or 
            user_tline.should_refresh(asmbl_config['SIMILARITY_DAYS_RECALC'])):
        print(f"Downloading timeline for user: {screen_name}")
        tapi = twitter.TwitterApi(asmbl_config['TWITTER_API_CREDS'])
        if (not tapi.user_exists(screen_name)): 
            raise UserNotFoundException(f'User: {screen_name} not found or does not exist in twitter')
        tline_data = tapi.timeline(screen_name, condense_factor=asmbl_config['TWEET_CONDENSE_FACTOR'])
        asmbl_models.TwmUserTimeline.persist(screen_name, tline_data)

    #  Recalc similarity score (if needed) + persist
    #  Check that refresh calc is within recalc period
    #  (same logic as user_tline)
    user_calc, calc_data = asmbl_models.TwmUserCalc.latest(screen_name, grp=group)
    if (force or user_calc is None or
            user_calc.should_refresh(asmbl_config['SIMILARITY_DAYS_RECALC'])):

        #  Execute Similarity Model
        #  Recalculate (or retrieve prior calculated) 
        print(f"Calculating similarity for user: {screen_name} on group: {group}")
        calc_data = calculate_scores(asmbl_config, screen_name, group, tline_data)
        asmbl_models.TwmUserCalc.persist(screen_name, group, calc_data)

    return calc_data


def calculate_scores(config: dict, screen_name: str, group: str='trumpian', tweet_timeline: list=[])-> dict:
    '''
    Given twitter user screen name, calculate similarity to a selection of
    model-calibrated twitter handles (by group).  Also calcs readability score
    Main controller / implementation; 

    This impl is env agnostic, in that we pass in the expected config objects
    rather than expect assembly framework

    Parameters:
        config: application configuration (dict-like object)
        screen_name: twitter handle to compare
        group: group of twitter handles to compare to
        tweet_timeline: tweet timeline for this user (list of strings); already processed
    Returns:
        dict of screen_names (in group to compare to), along with comparison metrics
    '''
    
    if tweet_timeline is None or len(tweet_timeline) < 1:
        raise Exception('User timeline is empty')

    #  User complexity scores
    user_complexity_scores = similarity.mdl_readability_scores(tweet_timeline)

    #  Get similarity model implementation group
    similarity_model_fn_name = config['SIMILARITY_COMPARISONS'][group]['similarity_function'] 
    similarity_model_fn = dict(inspect.getmembers(similarity, inspect.isfunction))[similarity_model_fn_name]
    
    #  Evaluate similarity to all members of group (each member has a calibrated model)
    similarity_analysis = {}
    compare_to_screen_names = config['SIMILARITY_COMPARISONS'][group]['screen_names']
    for comp_screen_name in compare_to_screen_names:
        similarity_analysis[comp_screen_name] = similarity_model_fn(group, comp_screen_name, tweet_timeline)
   
    #  -- Post Processing / Results Formatting --
    #  Extract average similarity score per reference personality
    #  Extract top / most similar tweets for each reference personality (>= 75% similarity)
    similarity_results = {}
    for comp_screen_name, similarity_df in similarity_analysis.items():
        avg_score = np.mean(similarity_df.y_prob)
        top_df = similarity_df[similarity_df.y_prob >= 0.75].sort_values('y_prob', ascending=False)
        top_similar = top_df.iloc[:3, :]
        similarity_results[comp_screen_name] = {
                    'avg_similarity_score': avg_score,
                    'top_similar': top_similar.to_dict('records')
                }
    
    results = {
        'evaluation': {
            'screen_name': screen_name,
            'group': group,
            'last_evaluation': datetime.date.today().strftime('%Y%m%d') 
        },
        'complexity_score': user_complexity_scores,
        'similarity': similarity_results
    }

    return results




