import pandas as pd
from lib.caching import cache
from assembly import models as asmbl_models


def mdl_multinomialnbvect_v1(grp: str, screen_name: str, tweets: list) -> pd.DataFrame:
    '''
    Top-line function for multinomial bayes calculation function
    Contains model-specific calibration behaviors
    The multinomial vect transforms tweet space to word vectors
    Then calcs prob of tweet being similar to screen_name in question

    Returns: pandas dataframe of probability of tweet belonging to particular author
        dataframe allows for manipulation / behavior spec further up the stack
    '''
   
    #  Transform tweets to vectorizer
    #  Transform incoming tweets to vectorized values
    vect_mdl = get_model(grp=grp, model_name='transformation-countvectorizer')
    x_vect = vect_mdl.transform(tweets)

    #  Predict probability via model
    screen_mdl = get_model(grp=grp, model_name=screen_name)

    #  Labels and their probabilities
    #  This model is trained to classify as true or false; 
    #  We want probability of TRUE, will constitute similarity score
    y_prob = screen_mdl.predict_proba(x_vect)
    y_true_idx  = 0 if (screen_mdl.classes_[0]) else 1
    y_prob_aligned = y_prob[:, y_true_idx]


    #  Construct DF of predicted values
    #  Return full results
    pred_df = pd.DataFrame({
        'text': tweets,
        'y_prob': y_prob_aligned,
        'y_sn': [screen_name] * len(tweets)  # set into dataframe, in case caller not tracking this
    })
    
    return pred_df


@cache.memoize()
def get_model(grp: str, model_name: str):
    '''
    Retrieves the appropriate calibrated model for a given "group"
    Each screen name has a particular model of concern
    '''

    #  There should be a single active row per screen name
    model_rows = asmbl_models.TwmSnModel.query().filter(
                    asmbl_models.TwmSnModel.model_name == model_name and \
                    asmbl_models.TwmSnModel.active == True)

    #  If DNE, will break (its okay)
    model_obj = model_rows[0].pckl
    return model_obj




