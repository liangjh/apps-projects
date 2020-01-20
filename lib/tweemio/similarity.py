
import assembly
from lib.caching import cache
from assembly import models as asmb_models




def calc_similarity()



@cache.memoize()
def get_model(grp: str, mdl_screen_name: str):
    '''
    Retrieves the appropriate calibrated model for a given "group"
    Each screen name has a particular model of concern
    '''

    #  There should be a single active row per screen name
    model_rows = asmb_models.TwmSnModels.query().filter(
                    asmb_models.TwmSnModels.screen_name == mdl_screen_name and \
                    asmb_models.TwmSnModels.active == True)

    #  If DNE, will break (its okay)
    model_obj = model_rows[0].pckl
    return model_obj




