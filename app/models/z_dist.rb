require 'linear_interpolation'

##
#  Z Distribution
class ZDist < ActiveRecord::Base
  attr_accessible :p_gt_zv, :p_lt_zv, :zv

  # Scopes - query assist
  scope :lt_zv,    lambda { |zvalue| where("zv < ?", zvalue).order(:zv) }
  scope :gt_zv,    lambda { |zvalue| where("zv > ?", zvalue).order(:zv) }
  scope :lt_alpha, lambda { |alpha|  where("p_lt_zv < ?", alpha).order(:p_lt_zv) }
  scope :gt_alpha, lambda { |alpha|  where("p_lt_zv > ?", alpha).order(:p_lt_zv) }


  class << self

    def by_zvalue(zvalue)
      zdist = find_by_zv(zvalue)
      zdist = interpolated_by_zvalue(zvalue) if zdist.nil?
      zdist
    end

    def by_alpha(alpha)
      interpolated_by_alpha(alpha)
    end

    def range_by_zvalue(zvalue)
      return self.lt_zv(zvalue).last, self.gt_zv(zvalue).first
    end

    def range_by_alpha(alpha)
      return self.lt_alpha(alpha).last, self.gt_alpha(alpha).first
    end

    private

    def interpolated_by_zvalue(zvalue)
      lower, upper = range_by_zvalue(zvalue)
      intp_p_lt_zv = LinearInterpolation.interpolate(lower.p_lt_zv, upper.p_lt_zv, lower.zv, upper.zv, zvalue)
      intp_p_gt_zv = LinearInterpolation.interpolate(lower.p_gt_zv, upper.p_gt_zv, lower.zv, upper.zv, zvalue)
      ZDist.new(zv: zvalue, p_lt_zv: intp_p_lt_zv, p_gt_zv: intp_p_gt_zv)
    end

    def interpolated_by_alpha(alpha)
      lower, upper = range_by_alpha(alpha)
      intp_zv = LinearInterpolation.interpolate(lower.zv, upper.zv, lower.p_lt_zv, upper.p_lt_zv, alpha)
      ZDist.new(zv: intp_zv, p_lt_zv: alpha, p_gt_zv: (1.0 - alpha))
    end

  end

end
