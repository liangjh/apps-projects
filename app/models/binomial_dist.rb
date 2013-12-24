require 'linear_interpolation'

##
#  Binomial Distribution
class BinomialDist < ActiveRecord::Base
  attr_accessible :n_trials, :p_cum, :p_point, :p_population, :x_success
  attr_accessor :left_dist, :right_dist

  #  Validations for new objects
  validates :n_trials, :presence => true
  validates :x_success, :presence => true
  validates :p_population, :presence => true
  validate :x_must_be_less_than_n

  def x_must_be_less_than_n
    if x_success.present? && n_trials.present?
      errors.add(:x_success, "must be between 1 and n-1") if (x_success < 1 || x_success >= n_trials)
    end
  end

  def range=(elem = [])
    self.left_dist = elem[0]
    self.right_dist = elem[1]
  end

end
