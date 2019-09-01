import types




def memoize(func: types.FunctionType) -> types.FunctionType:
    '''
    Decorator for memoization / caching
    Use this on functions w/ more intensive processing
    Be judicious about this,  there is no cleanup

    Parameters:
    func (types.FunctionType): function that performs action for caching

    '''
    cache = {}
    
    def decorated(*args, **kwargs):
        '''
        If the key implied by the arg/kwarg combination already exists,
        then return from cache; otherwise initialize and place into cache
        '''

        #  Assemble key for cache
        argkey = '_'.join([str(arg) for arg in args])
        kwargkey = '_'.join(['{}:{}'.format(str(k), str(v)) for k,v in kwargs])
        key = '{}__{}'.format(argkey, kwargkey)
        # print('checking key: {}'.format(key))

        if key not in cache.keys():
            value = func(*args, **kwargs)
            cache[key] = value
        
        return cache[key]

    return decorated

