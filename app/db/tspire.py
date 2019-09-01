import pandas
import datetime
from . import dbrelational


@dbrelational.dbaccess_write(datasource='tspire')
def tspire_save(guid: str, persona: str, img_file: str, title: str, text: str):
    '''
    Persists / saves a generated spire (all parameters passed)
    Decorator handles actual database save / persistenced, we just generate a SQL query
    Note that we construct a search vector (postgres only) to enable full text search on our generated spires
    '''
    
    sql = ''' 
        insert into t_spire (guid, persona, img_file, title, text, search_vector, created_at) 
        values ('{guid}', '{persona}', '{img_file}', '{title}', '{text}', to_tsvector('{text}'), '{created_at}');
    '''.format(guid=guid, persona=persona, img_file=img_file, 
               title=(title.replace("'", r"\'") if title is not None else title), 
               text=(text.replace("'", r"\'") if text is not None else text), 
               created_at=datetime.datetime.now())

    return sql


@dbrelational.dbaccess_read(datasource='tspire')
def tspire_latest(persona: str, num_spires: int=15) -> pandas.DataFrame:
    '''
    Returns the last x (num_spires) spires created for a particular persona
    '''
    return "select * from t_spire where persona='{}' order by created_at desc limit {};".format(persona, num_spires)


@dbrelational.dbaccess_read(datasource='tspire')
def tspire_search(persona: str, q: str, num_spires: int=15) -> pandas.DataFrame:
    '''
    Performs full-text search, w/ ranking on all generated spires for a particular persona
    This is very specific to postgres as it uses postgres search functions
    also returns a search rank score.
    '''
    q_tokens = q.split()
    if len(q_tokens) < 1:
        return None

    sql = '''
    select t_spire.*, 
           ts_rank_cd(search_vector, query) as rank 
    from t_spire, to_tsquery('{search_ts}') query 
    where t_spire.persona = '{persona}' 
        and query @@ search_vector 
    order by rank desc
    limit {num_spires};
    '''.format(persona=persona, num_spires=num_spires, 
               search_ts='|'.join([tok.replace("'", r"\'") for tok in q_tokens]))

    return sql

