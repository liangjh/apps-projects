require 'linear_interpolation'

##
#  Binomial Distribution
class BinomialDist < ActiveRecord::Base
  attr_accessible :n_trials, :p_cum, :p_point, :p_population, :x_success
end
