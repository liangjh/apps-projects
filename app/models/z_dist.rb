
##
#  Z Distribution
class ZDist < ActiveRecord::Base
  attr_accessible :p_gt_zv, :p_lt_zv, :zv
  attr_accessor :left_dist, :right_dist

  # Scopes - query assist
  scope :lt_zv,    lambda { |zvalue| where("zv < ?", zvalue).order(:zv) }
  scope :gt_zv,    lambda { |zvalue| where("zv > ?", zvalue).order(:zv) }
  scope :lt_alpha, lambda { |alpha|  where("p_lt_zv < ?", alpha).order(:p_lt_zv) }
  scope :gt_alpha, lambda { |alpha|  where("p_lt_zv > ?", alpha).order(:p_lt_zv) }


  class << self

    def range_by_zvalue(zvalue)
      [lt_zv(zvalue).last, gt_zv(zvalue).first]
    end

    def range_by_alpha(alpha)
      [lt_alpha(alpha).last, gt_alpha(alpha).first]
    end

  end

  def range=(elem = [])
    self.left_dist = elem[0]
    self.right_dist = elem[1]
  end

end
