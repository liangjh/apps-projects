require 'linear_interpolation'

##
#  Binomial Distribution
class BinomialDist < ActiveRecord::Base
  attr_accessible :n_trials, :p_cum, :p_point, :p_population, :x_success
  attr_accessor :left_dist, :right_dist

  def range=(elem = [])
    self.left_dist = elem[0]
    self.right_dist = elem[1]
  end

end
