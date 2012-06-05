require 'flickraw'

#//
#//  Gateway from saintstir to flickr, by way of the flickraw api.
#//  We plan to integrate caching of photo urls -
#//

class FlickrIntegration

  #//  Flickr API details
  cattr_accessor :api_key
  cattr_accessor :api_secret
  cattr_accessor :cache_enabled

  #//  Constants
  #//  Types of image sizes available
  SIZE_SQUARE_SMALL = "Square"
  SIZE_SQUARE_LARGE = "Large Square"
  SIZE_THUMBNAIL = "Thumbnail"
  SIZE_SMALL = "Small"
  SIZE_MEDIUM = "Medium"


  class << self

    #//  Retrieve photo, by ID and size
    def get_photo(photo_id, size = SIZE_MEDIUM)

      #// retrieve from cache, if enabled
      photo_link = nil
      if (cache_enabled)
        photo_link = get_from_cache(photo_id, size)
      end

      #//  retrieve from flickr, and save to cache
      if (photo_link.nil?)
        data = get_flickr_photos(photo_id)
        if (cache_enabled)
          save_to_cache(photo_id, data)
          photo_link = get_from_cache(photo_id, size)
        else
          data.each do |photo|
            photo_link = photo["source"]
            break if (photo["label"] == size)
          end
        end
      end

      photo_link #// return link to photo

    end

    def get_flickr_photos(photo_id)
      begin
        FlickRaw.api_key = api_key
        FlickRaw.shared_secret = api_secret
        flickr.photos.getSizes(:photo_id => photo_id)
      rescue Exception => err
        Rails.logger.error("FlickrIntegration :: failed to retrieve photo data from Flickr (photo_id => #{photo_id}): #{err}")
      end
    end

    def get_from_cache(photo_id, size)
      Rails.cache.get(get_cache_key(photo_id, size))
    end

    def save_to_cache(photo_id, data)
      data.each do |photo|
        Rails.cache.write(get_cache_key(photo_id, photo["label"]), photo["source"])
      end
    end

    def get_cache_key(photo_id, size)
      "#{photo_id} -- #{size}"
    end



  end


end
