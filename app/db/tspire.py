import pandas
import datetime
from . import dbrelational


@dbrelational.dbaccess_write(datasource='tspire')
def tspire_save(guid: str, persona: str, img_file_lg: str, img_file_sm: str, 
                title: str, text: str):
  
    keyvals = dict(zip(['guid', 'persona', 'img_file_lg', 'img_file_sm', 'title', 'text', 'created_at'],
                       [guid, persona, img_file_lg, img_file_sm, title, text, datetime.datetime.now()]))

    vals = ["'{}'".format(str(val)) if type(val) in [str, datetime.datetime] else "{}".format(str(val))
            for val in keyvals.values()]

    sql = 'insert into t_spire ({cols}) values ({vals});'.format(
            cols=",".join(keyvals.keys()), vals=",".join(vals))
    
    return sql


@dbrelational.dbaccess_read(datasource='tspire')
def tspire_latest(persona: str, num_spires: int=10) -> pandas.DataFrame:
    
    return "select * from t_spire where persona='{}' order by created_at desc limit {};".format(persona, num_spires)



