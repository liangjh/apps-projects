require 'linear_interpolation'

##
#  Binomial Distribution
class BinomialDist < ActiveRecord::Base
  attr_accessible :n_trials, :p_cum, :p_point, :p_population, :x_success
  attr_accessor :left_dist, :right_dist

  scope :lt_x, lambda { |x| where("x_success < ?", x).order(:x_success) }
  scope :gt_x, lambda { |x| where("x_success > ?", x).order(:x_success) }

  class << self

    def range_by_x_success(x)
      [lt_x(x).last, gt_x(x).first]
    end

  end

  def range=(elem = [])
    self.left_dist = elem[0]
    self.right_dist = elem[1]
  end

end
