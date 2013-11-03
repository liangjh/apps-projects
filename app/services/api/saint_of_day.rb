

##
#  This retrieves the current saint of the day
#  re-calculates the saint of day if necessary, but performs caching so th
#
class Api::SaintOfDay


  class << self

    def get
      get_cached do |effective_date|
        derive(effective_date)
      end
    end

    def get_cached(effective_date = Date.today)
      saint_featured_next_date = Setting.find_by_key(:saint_featured_next_date)
      saint_featured = Setting.find_by_key(:saint_featured)


      # If any of these values are nil, then re-derive
      if saint_featured_next_date.value.nil? || Date.parse(saint_featured_next_date.value) < effective_date
        next_mvs = yield effective_date
        save_next(next_mvs, saint_featured, saint_featured_next_date, effective_date)
      end

      #  Retrieve the actual featured saint
      Saint.find(saint_featured.value)
    end

    ##
    #  Retrieves all saints and derives the current and next saints to display
    def derive(effective_date)
      this_yr = Date.today.year
      mvs = MetadataValue.where(:metadata_key_id => MetadataKey.find_by_code(:feastday))
      sorted_mvs = mvs.sort { |x,y| Date.parse("#{this_yr}/#{x.value}") <=> Date.parse("#{this_yr}/#{y.value}") }
      next_feasts = sorted_mvs.select { |x| Date.parse("#{this_yr}/#{x.value}") >= effective_date }.first(2)
      next_feasts
    end

    def save_next(next_mvs, saint_featured, saint_featured_next_date, effective_date)
      saint_featured.value = next_mvs.size > 0 ? next_mvs[0].saint_id.to_s : Saint.first.id
      saint_featured_next_date.value = next_mvs.size > 1 ? "#{effective_date.year}/#{next_mvs[1].value}" : effective_date.strftime("%Y/%m/%d")
      saint_featured.save
      saint_featured_next_date.save
    end
  end


end

