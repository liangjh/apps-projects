##
#  This retrieves the current saint of the day
#  re-calculates the saint of day if necessary, but performs caching so
#  that we don't need to re-calculate for each hit to saint of the day
#
class Api::SaintOfDay


  class << self

    def get
      get_cached do |effective_date|
        derive(effective_date)
      end
    end

    def get_cached(effective_date = Date.today)
      saint_featured = Setting.find_by_key(:saint_featured)

      # If any of these values are nil, then re-derive
      if saint_featured.updated_at.to_date < effective_date
        next_mv = yield effective_date
        saint_featured.update_attribute(:value, next_mv.saint_id.to_s)
      end

      #  Retrieve the actual featured saint
      Saint.find(saint_featured.value)
    end


    ##
    #  Retrieves all saints and derives the current and next saints to display
    def derive(effective_date)
      mvs = MetadataValue.where(:metadata_key_id => MetadataKey.find_by_code(:feastday))

      #  Find the next day's set of saints
      this_yr = Date.today.year
      sorted_mvs = mvs.sort { |x,y| Date.parse("#{this_yr}/#{x.value}") <=> Date.parse("#{this_yr}/#{y.value}") }
      next_feast_mv = sorted_mvs.find { |mv| Date.parse("#{this_yr}/#{mv.value}") >= effective_date }
      next_feast_mv = sorted_mvs.first if next_feast_mv.nil?   # No more this year - start from beginning again

      # All saints w/ same date as next_feast_mv - choose one at random
      candidate_mvs = sorted_mvs.select { |mv| mv.value == next_feast_mv.value }
      winner_mv = candidate_mvs[rand(candidate_mvs.length)]
    end

  end


end

