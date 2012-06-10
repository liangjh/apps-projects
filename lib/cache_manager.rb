
#//
#//  CacheManager
#//  This is the main gateway class to caching within saintstir
#//

class CacheManager

  #//  All class / utility methods
  class << self

    #// Configuration -- contains a array of CacheConfig objects
    def configure=(config_list)
      @@config_map = {}
      config_list.each do |cfg|
        @@config_map[cfg.cache_partition] = cfg
      end
    end

    #// Write to cache.
    def write(partition, key=nil, value)
      Rails.cache.write(get_key(partition, key), value)
    end

    #// Read data from cache
    def read(partition, key=nil)
      Rails.cache.read(get_key(partition, key))
    end

    #// Read data from cache, in a rails-like manner (i.e if the
    #// partition is a view, then will prepend "view/" to the front of the partition-key combo)
    def read_railsy(partition, key=nil)
      Rails.cache.read(get_rails_key(partition, key))
    end

    def exist?(partition, key=nil)
      Rails.cache.exist?(get_rails_key(partition, key))
    end

    #//  Returns the key for a given cache key = partition/key
    #//  If no key is provided, then the key returned will just be the partition
    #//  (i.e. singleton cache partition)
    def get_key(partition, key=nil)
      partition if (key.nil?)  #// this is the case where the partition is a singleton
      "#{partition}/#{key}"
    end

    #//  Returns the RAILS key for a given cache key
    #//  If a partition is configured as type "view", then "view/" will be
    #//  prepended in front of the partion/key combo, since this is how rails
    #//  fragment caching works
    def get_rails_key(partition, key=nil)
      rails_key = ""
      if (!@@config_map[partition].nil? && @@config_map[partition].is_view?)
        rails_key += "#{CacheConfig::CACHE_PREFIX_VIEWS}/"
      end
      rails_key += partition
      rails_key += "/#{key}" if (!key.nil?)
      rails_key
    end

    def flush_all_for_saint(saint_id)
      partitions = [CacheConfig::PARTITION_SAINT_BLURB, CacheConfig::PARTITION_FLICKR_SOURCE]
      partitions.each do |ption|
        rk = get_rails_key(ption, saint_id)
        Rails.logger.info("CacheManager :: deleting from cache: #{rk}")
        Rails.cache.delete(rk)
      end
    end

  end

end


class CacheConfig

  #// Cache Partitions
  PARTITION_SAINT_BLURB = "saint_blurb"
  PARTITION_SAINTS_ISOTOPE = "saints_isotope"
  PARTITION_FLICKR_SOURCE = "flickr_source"

  #// Properties obj/view
  CACHE_TYPE_VIEW = "view"
  CACHE_TYPE_OBJ  = "obj"
  CACHE_PREFIX_VIEWS = "views"

  attr_accessor :cache_partition, :cache_type


  def initialize(cache_partition, cache_type)
    @cache_partition = cache_partition
    @cache_type = cache_type
  end

  def is_view?
    (@cache_type == CACHE_TYPE_VIEW)
  end

  def has_prefix?
    (!@prefix.nil?)
  end

end

