import pandas
import psycopg2
import types
from app import app


# Note: in the below, we assume that app.config has already been initialized
# by the application (if not passed in).  Otherwise, need to pass in database connections
# Additionally, database assumed to be postgres

def dbaccess_read(datasource:str, config: dict=app.config['DATABASE_CONNECTIONS']):
    '''
    Wrapper function for READ access to the database

    Parameters:
      datasource: name of datasource in configuration 
      config: connection properties mapping
    '''
    def decorator(func: types.FunctionType) -> types.FunctionType:

        def decorated(*args, **kwargs) -> pandas.DataFrame:

            connparams = config[datasource]
            sql  = func(*args, **kwargs)
            
            try: 
                conn = psycopg2.connect(**connparams)
                df   = pandas.read_sql(sql, conn)
            finally:
                if conn is not None:
                    conn.close()
            
            return df
    
        return decorated

    return decorator


#  TODO: can make this more generic, currently func needs to generate inesrt / update statement
def dbaccess_write(datasource: str, config: dict=app.config['DATABASE_CONNECTIONS']):
    '''
    Executes SQL to write to database
    The function returns the actual SQL for now, 

    Parameters:
      datasource: 
      config: connection parameters
    '''
    def decorator(func: types.FunctionType) -> types.FunctionType:

        def decorated(*args, **kwargs):

            sql = func(*args, **kwargs)
            connparams = config[datasource]
            
            try: 
                conn = psycopg2.connect(**connparams)
                crsr = conn.cursor()
                crsr.execute(sql)
                crsr.close()
                conn.commit()
            finally:
                if conn is not None: 
                    conn.close()

        return decorated

    return decorator


