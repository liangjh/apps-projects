import pandas
import datetime
from . import dbrelational


@dbrelational.dbaccess_write(datasource='tspire')
def tspire_save(guid: str, persona: str, img_file: str, title: str, text: str):
  
    #  Note: the search_vector uses postgres functionality (tokenize / stemming of text to allow for optimized search behavior)
    sql = ''' 
        insert into t_spire (guid, persona, img_file, title, text, search_vector, created_at) 
        values ('{guid}', '{persona}', '{img_file}', '{title}', '{text}', to_tsvector('{text}'), '{created_at}');
    '''.format(guid=guid, persona=persona, img_file=img_file, title=title, text=text, created_at=datetime.datetime.now())

    return sql


@dbrelational.dbaccess_read(datasource='tspire')
def tspire_latest(persona: str, num_spires: int=15) -> pandas.DataFrame:
    
    return "select * from t_spire where persona='{}' order by created_at desc limit {};".format(persona, num_spires)



