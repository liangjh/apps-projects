
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

    def render_by_type(type)
      case type
        when FEASTDAY
          render_feast
        else
          render_feast
      end
    end


    def render_feast

      mkey = MetadataKey.find_by_code(MetadataKey::FEASTDAY)
      mvs  = MetadataValue.find_all_by_metadata_key_id(mkey.id)

      {
        :key => 'value',
        :key2 => 'value2'
      }

    end

  end

end

