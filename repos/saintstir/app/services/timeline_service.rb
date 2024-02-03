
##
#  Performs logic of retrieveing data for particular timeline views in json
#  Compatible with timelinejs rendering library
#
class TimelineService
  cattr_accessor :timelines
  cattr_accessor :cache_data

  class << self

    def render_timeline_options
      self.timelines.map do |timeline|
        [timeline.name, timeline.type]
      end
    end

    def timeline_by_type(type)
      tline = self.timelines.select { |tl| tl.type == type }
      tline.first if !tline.empty?
    end

    def render_by_type(type, refresh = false)

      #  Retrieve data from cache - return if its not nil and we're not explicitly refreshing
      if cache_data
        data_json = CacheManager.read(CacheConfig::PARTITION_TIMELINE, type)
        return data_json if !refresh && data_json.present?
      end

      ##
      #  Refresh, or re-derive timeline data
      #  Retrieve fresh data, find applicable timeline first
      tline = self.timelines.select { |tl| tl.type == type }
      data_json = tline.empty? ? nil : tline.first.render.to_json

      #  Write to cache for this partition
      CacheManager.write(CacheConfig::PARTITION_TIMELINE, type, data_json) if cache_data
      data_json
    end


  end

end

