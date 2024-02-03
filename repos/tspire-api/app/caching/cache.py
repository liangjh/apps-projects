import types
import datetime


def memoize(ttl_sec: int=None) -> types.FunctionType:
    '''
    Decorator for memoization / caching
    Use this on functions w/ more intensive processing
    Be judicious about this,  there is no cleanup

    Parameters:
        ttl_sec: for keys for this particular function, number of seconds is the TTL for each cache entry 
    '''

    def decorator(func: types.FunctionType) -> types.FunctionType:

        cache = {}
        cache_datetime = {}
        
        def decorated(*args, **kwargs):
            '''
            If the key implied by the arg/kwarg combination already exists,
            then return from cache; otherwise initialize and place into cache
            '''

            #  Assemble key for cache
            argkey = '_'.join([str(arg) for arg in args])
            kwargkey = '_'.join(['{}:{}'.format(str(k), str(v)) for k,v in kwargs])
            key = '{}__{}'.format(argkey, kwargkey)

            #  Cache cleanup
            if (ttl_sec is not None and key in cache_datetime.keys()):
                dt_now = datetime.datetime.now()
                dt_cached = cache_datetime[key]
                if ((dt_now - dt_cached).total_seconds() > ttl_sec):
                    del cache[key]
                    del cache_datetime[key]

            #  Initialize, if applicable
            if (key not in cache.keys()):
                value = func(*args, **kwargs)
                cache[key] = value
                cache_datetime[key] = datetime.datetime.now()
            
            return cache[key]

        return decorated

    return decorator

