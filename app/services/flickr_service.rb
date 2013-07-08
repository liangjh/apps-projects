require 'flickraw'

#//
#//  Gateway from saintstir to flickr, by way of the flickraw api.
#//  We plan to integrate caching of photo urls -
#//

class FlickrService

  #// Flickr API details
  #// Attribs necessary for api (key, secret, owner_id)
  #// cache_enabled = true will turn on caching
  cattr_accessor :api_key, :api_secret, :cache_enabled, :owner_id

  #//  Constants
  #//  Types of image sizes available
  SIZE_SQUARE_SMALL = "url_sq"
  SIZE_SMALL = "url_s"
  SIZE_THUMB = "url_t"
  SIZE_MEDIUM = "url_m"


  class << self

    #//  Retrieve photo, by ID and size
    def get_photo(saint_id, photoset_id, photo_id, size = SIZE_MEDIUM)

      #// retrieve all photos in photoset
      photo_data = get_photoset_photos(saint_id, photoset_id, size)

      #// given photoset data, retrieve link for selected size
      photo_link = ""
      photo_data.each do |photo|
        photo_link = photo[size]
        break if (photo["id"] == photo_id)
      end
      photo_link #// return link to photo
    end

    #//  Returns a list of photo links, (all in the same photoset)
    def get_photos(saint_id, photoset_id, size = SIZE_MEDIUM)
      photo_data = get_photoset_photos(saint_id, photoset_id, size)
      photos = []
      photo_data.each do |photo|
        photos << photo[size]
      end
      photos
    end

    #//  Returns an array of photo objects, for a given photoset
    def get_photoset_photos(saint_id, photoset_id, size = SIZE_MEDIUM)
      #// retrieve from cache, if enabled
      photo_data = nil
      if (cache_enabled)
        photo_data = CacheManager.read(CacheConfig::PARTITION_FLICKR_SET, saint_id)
      end
      #//  retrieve from flickr, and save to cache
      if (photo_data.nil?)
        data = get_flickr_photos(photoset_id)
        if (!data.nil? && cache_enabled)
          CacheManager.write(CacheConfig::PARTITION_FLICKR_SET, saint_id, data)
        end
        photo_data = data
      end
      photo_data
    end


    #// Retrieves all info for photoset
    def get_flickr_photos(photoset_id)
      Rails.logger.info("Retrieving photo data from Flickr (photoset_id: #{photoset_id})")
      result = []
      begin
        FlickRaw.api_key = api_key
        FlickRaw.shared_secret = api_secret
        # flickr.photos.getSizes(:photo_id => photo_id)
        result = flickr.photosets.getPhotos(:photoset_id => photoset_id,
                                   :extras => "#{SIZE_SQUARE_SMALL},#{SIZE_SMALL},#{SIZE_MEDIUM}").photo
      rescue Exception => err
        Rails.logger.error("FlickrService :: failed to retrieve photo data from Flickr (photoset_id => #{photoset_id}): #{err}")
      end
      result
    end

  end


end
