require 'cache_manager'

#//  Initialize all cache types that are tracked
#//  We'll be using the SaintstirCacheManager to manage all caching

CacheManager.configure = [
  CacheConfig.new(CacheConfig::PARTITION_SAINTS_ISOTOPE, CacheConfig::CACHE_TYPE_VIEW, true, true),
  CacheConfig.new(CacheConfig::PARTITION_SAINT_BLURB, CacheConfig::CACHE_TYPE_VIEW, true, false),
  CacheConfig.new(CacheConfig::PARTITION_SAINT_WIKI_BIO, CacheConfig::CACHE_TYPE_OBJ, true, false),
  CacheConfig.new(CacheConfig::PARTITION_FLICKR_SET, CacheConfig::CACHE_TYPE_OBJ, true, false),
  CacheConfig.new(CacheConfig::PARTITION_TIMELINE, CacheConfig::CACHE_TYPE_OBJ, false, false)
]


