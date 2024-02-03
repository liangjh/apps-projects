
##
#  Timeline render method for feast days
#
module Timeline

  class Feastday < Base


    def type
      "feastday"
    end

    def name
      "Feast Day"
    end

    ##
    #  Render the feast day
    def render

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
            :text => saint_display_text(saint),
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
          :text => "Timeline of all saints in saintstir, by feast day",
          :asset => {},
          :date => saint_dates
        }
      }
    end

  end
end
