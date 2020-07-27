import datetime
import inspect
from lib.tweemio import similarity
from lib.tweemio import twitter

from assembly import models as asmbl_models
from assembly import config as asmbl_config


class UserNotFoundException(Exception):
    pass


def api_user_details(screen_name: str, force: bool=False):
    '''
    Invoked by API endpoint
    Retrieve user, download timeline and calculate readability score for user
    Returns in dict, serialize to json
    '''
    
    #  Retrieve persisted user info, or re-download / recalculate
    #  All logic handled in calculate_user function
    #  We don't need to return user timeline
    user, timeline = calculate_user(screen_name, force=force)

    return {
        'user': {
            'screen_name': screen_name,
            'name': user.name,
            'desc': user.desc,
            'profile_img': user.profile_img
        },
        'readability': user.readability
    }


def api_calculate_similarity(screen_name: str, group: str='trumpian', force: bool=False) -> dict:
    '''
    Invoked by API endpoint
    Gateway function to similarity score calculation
    Check if user has calculated using this group within last N days (N = analysis barrier)
    If so, then pull latest results from persistent store location (gcs or local)
    If no, recalculate;  Persist results ref to database, store to persistence location (gcs or local)
    '''

    #  Get latest tline data, if exists
    #  Download user timeline (if needed) + persist
    user_tline, tline_data = calculate_user(screen_name, force)

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


def calculate_user(screen_name: str, force: bool=False):
    '''
    Retrieve and process user by screen name
    Retrieve only if user profile has not been downloaded since threshold 
     (1) user details (2) timeline, (3) calculates user readability scores
    '''
    user_tline, tline_data = asmbl_models.TwmUserTimeline.latest(screen_name)
    if (force or user_tline is None or 
            user_tline.should_refresh(asmbl_config['SIMILARITY_DAYS_RECALC'])):
        
        print(f"Downloading user / processing timeline / calc readability for user: {screen_name}")
        
        tapi = twitter.TwitterApi(asmbl_config['TWITTER_API_CREDS'])
        user = tapi.user(screen_name)
        if user is None:
            raise UserNotFoundException(f'User: {screen_name} not found or does not exist in twitter')

        #  Download user timeline
        tline_data = tapi.timeline(screen_name, condense_factor=asmbl_config['TWEET_CONDENSE_FACTOR'])

        #  Calculate readability scores
        user_readability_scores = similarity.mdl_readability_scores(tline_data)

        #  Persist (user profile, readability scores, timeline)
        asmbl_models.TwmUserTimeline.persist(screen_name=screen_name, name=user.name, desc=user.description,
                                             profile_img=user.profile_image_url_https, 
                                             readability=user_readability_scores, data=tline_data)

        #  Re-retrieve, for consistent handling
        user_tline, tline_data = asmbl_models.TwmUserTimeline.latest(screen_name)

    return user_tline, tline_data



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

    #  Get similarity model implementation group
    similarity_model_fn_name = config['SIMILARITY_COMPARISONS'][group]['similarity_function'] 
    similarity_model_fn = dict(inspect.getmembers(similarity, inspect.isfunction))[similarity_model_fn_name]
    
    #  Evaluate similarity to all members of group (each member has a calibrated model)
    similarity_df, model_labels = similarity_model_fn(group, tweet_timeline)
   
    #  -- Post Processing / Results Formatting --
    #  Extract average similarity score per reference personality
    #  Extract top / most similar tweets for each reference personality (>= 75% similarity)
    similarity_results = {}
    for comp_screen_name in model_labels:
        avg_score = similarity_df[comp_screen_name].mean()
        top_df = similarity_df[[comp_screen_name, 'text']].sort_values(comp_screen_name, ascending=False)
        top_similar = top_df[top_df[comp_screen_name] > 0.75].iloc[:3, :]
        similarity_results[comp_screen_name] = {
                    'avg_similarity_score': avg_score,
                    'top_similar': top_similar.rename(columns={comp_screen_name: 'score'}).to_dict('records')  # return score, text (not screen name)
                }
    
    results = {
        'evaluation': {
            'screen_name': screen_name,
            'group': group,
            'last_evaluation': datetime.date.today().strftime('%Y%m%d') 
        },
        'similarity': similarity_results
    }

    return results




