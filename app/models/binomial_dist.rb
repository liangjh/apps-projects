##
#  Binomial Distribution
class BinomialDist < ActiveRecord::Base
  attr_accessible :n_trials, :p_cum, :p_point, :p_population, :x_success

  class << self

    ##
    #  Returns distribution (cum and point),
    #  (given n, x, and p)
    def distribution(n_trials, x_success, p_population)
      BinomialDist.find_by_n_trials_s_success_and_p_population(n_trails, x_success, p_population)
    end

  end


end
