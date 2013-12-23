require 'linear_interpolation'

##
#  Binomial Distribution
class BinomialDist < ActiveRecord::Base
  attr_accessible :n_trials, :p_cum, :p_point, :p_population, :x_success

  #  Validations for new requests
  validates :n_trials, :presence => true
  validates :x_success, :presence => true
  validates :p_population, :presence => true

end
