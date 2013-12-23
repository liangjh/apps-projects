require 'linear_interpolation'

##
#  Binomial Distribution
class BinomialDist < ActiveRecord::Base
  attr_accessible :n_trials, :p_cum, :p_point, :p_population, :x_success

  class << self

    ##
    #  Returns distribution (cum and point),
    #  (given n, x, and p)
    def by_n_x_p(n, x, p)
      BinomialDist.find_by_n_trials_x_success_and_p_population(n, x, p)
    end

  end


end
