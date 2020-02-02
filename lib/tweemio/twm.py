import datetime
import uuid
import numpy as np
import inspect
from lib.tweemio import similarity
from lib.tweemio import twitter
from lib.tweemio import filepersist

from assembly import models as asmbl_models


class UserNotFoundException(Exception):
    pass



def calculate(config: dict, screen_name: str, group: str='trumpian', force: bool=False) -> dict:
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
  
    #  Check if user has a prior eval / calc on this group
    #  Does calc exist for this user
    user_calc = list(asmbl_models.TwmUserCalc.query().filter(
            (asmbl_models.TwmUserCalc.grp == group) & (asmbl_models.TwmUserCalc.screen_name == screen_name)))
    user_calc = user_calc[0] if (user_calc != None and len(user_calc) > 0) else None

    #  Determine if we need to recalc similarity for this group
    #  Recalc if last calc prior to staleness period (days);  or if "force" is true
    recalc = (user_calc is None or force)  # no prior calc or we want to force a recalc
    if (not recalc and user_calc is not None):  # recalc not already set and user_calc actually exists (eval staleness)
        last_update = user_calc.updated_at.date()
        days_since  = (datetime.date.today() - last_update).days
        recalc = days_since > config['SIMILARITY_DAYS_RECALC']

    #  Execute Similarity Model
    #  Recalculate (or retrieve prior calculated) 
    similarity_data = calculate_scores(config, screen_name, group) if recalc else \
                            filepersist.read_json(config['PERSISTENCE'], assemble_filename(screen_name, group, user_calc.uuid))
    
    #  Persist recalculated data (if recalculated)
    if recalc:
        guid = uuid.uuid4().hex  # new guid 
        filepersist.save_json(config['PERSISTENCE'], assemble_filename(screen_name, group, guid), similarity_data)
        if (user_calc is not None):
            user_calc.delete()
        asmbl_models.TwmUserCalc.create(screen_name=screen_name, grp=group, uuid=guid)
   
    return similarity_data


def calculate_scores(config: dict, screen_name: str, group: str='trumpian')-> dict:
    '''
    Given twitter user screen name, calculate similarity to a selection of
    model-calibrated twitter handles (by group).  Also calcs readability score
    Main controller / implementation; 

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


def assemble_filename(screen_name: str, grp: str, guid: str) -> str:
    if (guid is None):
        guid = uuid.uuid4().hex
    return f"{screen_name}--{grp}--{guid}.json"



