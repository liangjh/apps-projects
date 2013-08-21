
##
#  Performs logic of retrieveing data for particular timeline views, and
#  constructing JSON data
#
class TimelineService

  module Types
    FEASTDAY   = "feastday"
    CENTURY     = "century"
    EUROPERIOD = "europeriod"
  end


  class << self

    def timeline_types

    end

    def render_by_type(type)
      case type
        when FEASTDAY
          render_feast
        else
          render_feast
      end
    end


    ##
    #  Render the feast day
    def render_feast

      ##
      #  Get all saints, and construct their feast day hashes
      saints = Saint.all_published
      saint_dates = saints.map do |saint|
        mv_values = saint.map_metadata_values_by_code
        feastday = saint.get_metadata_value(MetadataKey::FEASTDAY)

        if feastday.present?
          year  = Date.today.year
          month = feastday.split("/")[0]
          date  = feastday.split("/")[1]
          feastday_date = Date.parse("#{year}#{month}#{date}")

          {
            :startDate => feastday_date.strftime("%Y,%m,%d"),
            :headline => saint.symbol,
            :text => saint.get_metadata_value(MetadataKey::NAME),
            :asset => {
              :media => get_pic(saint),
              :thumbnail => get_thumbnail(saint)
            }
          }
        end
      end

      #  Remove any saints that don't fit rendering criteria
      saint_dates = saint_dates.reject { |obj| obj.nil? }

      ##  Render all
      {
        :timeline => {
          :headline => "Saint Feast Days",
          :type => "default",
          :text => "Saints in saintstir, by feast day",
          :asset => {},
          :date => saint_dates
        }
      }
    end


    private

    def get_thumbnail(saint)
      FlickrService.get_photo(saint.id,
                              saint.get_metadata_value(MetadataKey::FLICKR_SET),
                              saint.get_metadata_value(MetadataKey::FLICKR_PROFILE),
                              FlickrService::SIZE_SMALL)
    end

    def get_pic(saint)
      FlickrService.get_photo(saint.id,
                              saint.get_metadata_value(MetadataKey::FLICKR_SET),
                              saint.get_metadata_value(MetadataKey::FLICKR_PROFILE)
    end


  end

end

