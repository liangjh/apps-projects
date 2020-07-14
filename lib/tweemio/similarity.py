# import re
import spacy
import spacy_readability
import pandas as pd
import numpy as np

from lib.caching import cache
from assembly import models as asmbl_models


def mdl_multinomialnbvect_v1(grp: str, tweets: list) -> list:
    '''
    Top-line function for multinomial bayes calculation function
    Contains model-specific calibration behaviors
    The multinomial vect transforms tweet space to word vectors
    Then calcs prob of tweet being similar to screen_name in question

    Returns: pandas dataframe of probability of tweet belonging to all authors in group
        + list of all available classifications
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

    #  Retrieve models (vectorize, similarity)
    vect_mdl = asmbl_models.TwmSnModel.get_model(grp=grp, model_name='mnbv1-vectorizer')
    simi_mdl = asmbl_models.TwmSnModel.get_model(grp=grp, model_name='mnbv1-similarity')

    #  Run calibrated model on incoming text
    x_vect = vect_mdl.transform(tline_text)
    y_prob = simi_mdl.predict_proba(x_vect)

    #  Assemble model classification results
    #  Align classes w/ probabilities (same order)
    similarity_df = pd.concat([
                            pd.DataFrame(y_prob, columns=simi_mdl.classes_),  # predicte probabilities, all classes
                            pd.DataFrame({'text': tline_text})  # original incoming tweet stream
                        ], axis=1)

    #  Return all probabilities, + all cateogrized classes
    return similarity_df, list(simi_mdl.classes_)


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





