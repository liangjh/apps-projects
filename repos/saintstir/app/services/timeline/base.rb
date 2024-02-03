module Timeline
  class Base

    #  By default, do not start w/ a specific zoom level
    #  Individual timelines can define zoom adjustments
    def zoom_adjustment
      0
    end

    def get_thumbnail(saint)
      FlickrService.get_photo(saint.id,
                              saint.get_metadata_value(MetadataKey::FLICKR_SET),
                              saint.get_metadata_value(MetadataKey::FLICKR_PROFILE),
                              FlickrService::SIZE_SMALL)
    end

    def get_pic(saint)
      FlickrService.get_photo(saint.id,
                              saint.get_metadata_value(MetadataKey::FLICKR_SET),
                              saint.get_metadata_value(MetadataKey::FLICKR_PROFILE))
    end

    def saint_display_text(saint)
      text_data = "#{saint.get_metadata_value(MetadataKey::NAME)}"\
                  "<br/>#{saint.get_attrib(AttribCategory::CENTURY)} Century"\
                  "<br/>#{saint.get_attrib(AttribCategory::PERIODEUROCENTRIC)}"\
                  "<br/><a href='/saints/#{saint.id}'>View Saint Profile</a>"

      text_data
    end

  end
end
