# import re
import spacy
import spacy_readability
import pandas as pd
import numpy as np

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
    
    #  Create synthetic tweet stream for model, separating mentions
    #  Derive lemmatized words;  then add mentions;  this gets transformed
    #  Lemmatize, then reconstitute mentions with lemmatized non-mentioned text field

    tline_text = tweets.copy()

    # tline_text_nomention = [' '.join([('' if (re.match(r'^(@|#|http)', word) != None) else word) for word in text.split()]).strip() for text in tline_text]    
    # tline_text_mention   = [' '.join([('' if (re.match(r'^(@|#)', word) == None) else word) for word in text.split()]).strip() for text in tline_text]
    # nlp = get_nlp_basic()
    # tline_text_nomention = [' '.join([tok.lemma_ for tok in nlp(text)]) for text in tline_text_nomention]
    # tline_text = [nom + ' ' + mn for nom,mn in list(zip(tline_text_nomention, tline_text_mention))]

    #  Transform tweets to vectorized according to training set
    vect_mdl = get_model(grp=grp, model_name='transformation-countvectorizer')
    x_vect = vect_mdl.transform(tline_text)

    #  Predict probability via model
    screen_mdl = get_model(grp=grp, model_name=screen_name)

    #  Labels and their probabilities
    #  This model is trained to classify as true or false; 
    #  We want probability of TRUE, will constitute similarity score
    y_prob = screen_mdl.predict_proba(x_vect)
    y_true_idx  = 0 if (screen_mdl.classes_[0]) else 1  # Which label is true? class: 0,1 
    y_prob_aligned = y_prob[:, y_true_idx]

    #  Construct DF of predicted values
    #  Return full results
    pred_df = pd.DataFrame({
        'text': tweets,
        'y_prob': y_prob_aligned,
        'y_sn': [screen_name] * len(tweets)  # set into dataframe, in case caller not tracking this
    })
    
    return pred_df


def mdl_readability_scores(tweets: list) -> dict:
    '''
    Compile readability scores on full tweet list
    Uses spacy readability library
    Various grade-level scores are compiled
    '''

    #  NLP parser, parse all tweets
    nlp_parser = get_nlp_readability()
    nlpdocs = [nlp_parser(tweet) for tweet in tweets]

    fkgl  = [nlpdoc._.flesch_kincaid_grade_level for nlpdoc in nlpdocs]
    fkre  = [nlpdoc._.flesch_kincaid_reading_ease for nlpdoc in nlpdocs]
    dcidx = [nlpdoc._.dale_chall for nlpdoc in nlpdocs]
    clidx = [nlpdoc._.coleman_liau_index for nlpdoc in nlpdocs]
    autor = [nlpdoc._.automated_readability_index for nlpdoc in nlpdocs]

    avg_results = {
        'flesch_kincaid_grade_level': np.mean(fkgl),
        'flesch_kincaid_reading_ease': np.mean(fkre),
        'dale_chall': np.mean(dcidx),
        'coleman_liau_index': np.mean(clidx),
        'automated_readability_index': np.mean(autor)
    }

    return avg_results


@cache.memoize()
def get_nlp_readability():
    '''
    NLP parser with most features disabled
    Add sentencizer for grade-level complexity scores;
    We can expand to have different NLP versions for various purposes if needed in the future
    '''
    nlp = spacy.load("en_core_web_sm")

    nlp.disable_pipes(*['tagger','parser','ner'])
    nlp.add_pipe(nlp.create_pipe('sentencizer'))  # we only need sentence parsing
    nlp.add_pipe(spacy_readability.Readability(), last=True)

    return nlp


@cache.memoize()
def get_model(grp: str, model_name: str):
    '''
    Retrieves the appropriate calibrated model for a given "group"
    Each screen name has a particular model of concern
    '''
    #  There should be a single *active* row per model name
    #  TODO: perhaps move queries like this to model object?
    model_rows = asmbl_models.TwmSnModel.query().filter(
                    (asmbl_models.TwmSnModel.grp == grp) & \
                    (asmbl_models.TwmSnModel.model_name == model_name) & \
                    (asmbl_models.TwmSnModel.active == True))

    #  If DNE, will break (its okay)
    model_obj = model_rows[0].pckl
    return model_obj




