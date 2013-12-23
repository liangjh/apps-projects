require 'linear_interpolation'

##
#  T Distribution (Student's Distribution)
class TDist < ActiveRecord::Base
  attr_accessible :alpha, :df, :p_cum, :tv_1t, :tv_2t

  # Additional, attachable attribs
  attr_accessor :max_lt, :min_gt

  scope :lt_alpha,  lambda { |alpha, df| where("alpha < ? and df = ?", alpha, df).order(:alpha) }
  scope :lt_tv_one, lambda { |tval, df|  where("tv_1t < ? and df = ?", tval,  df).order(:tv_1t) }
  scope :lt_tv_two, lambda { |tval, df|  where("tv_2t < ? and df = ?", tval,  df).order(:tv_2t) }
  scope :gt_alpha,  lambda { |alpha, df| where("alpha > ? and df = ?", alpha, df).order(:alpha) }
  scope :gt_tv_one, lambda { |tval, df|  where("tv_1t > ? and df = ?", tval,  df).order(:tv_1t) }
  scope :gt_tv_two, lambda { |tval, df|  where("tv_2t > ? and df = ?", tval,  df).order(:tv_2t) }

  class << self

    def by_alpha_and_df(alpha, df)
      tdist = find_by_alpha_and_df(alpha, df)
      tdist = interpolated_by_alpha(alpha, df) if tdist.nil?
      tdist
    end

    def by_tv_one_sided_and_df(tv, df)
      TDist.find_by_tv_1t_and_df(tv, df)
    end

    def by_tv_two_sided_and_df(tv, df)
      TDist.find_by_tv_2t_and_df(tv, df)
    end

    def range_by_alpha(alpha, df)
      return self.lt_alpha(alpha, df).last, self.gt_alpha(alpha, df).first
    end

    def range_by_tv_one_sided(tv, df)
      return self.lt_tv_one(tv, df).last, self.gt_tv_one(tv, df).first
    end

    def range_by_tv_two_sided(tv, df)
      return self.lt_tv_two(tv, df).last, self.gt_tv_two(tv, df).first
    end

    private

    def interpolated_by_alpha(alpha, df)
      lower, upper = range_by_alpha(alpha, df)
      intp_tv_one = LinearInterpolation.interpolate(lower.tv_1t, upper.tv_1t, lower.alpha, upper.alpha, alpha)
      intp_tv_two = LinearInterpolation.interpolate(lower.tv_1t, upper.tv_2t, lower.alpha, upper.alpha, alpha)
      TDist.new(alpha: alpha, df: df, tv_1t: intp_tv_one, tv_2t: intp_tv_two, p_cum: (1.0 - alpha))
    end

    def interpolated_by_tv_one_sided(tv, df)
      lower, upper = range_by_tv_one_sided(tv, df)
      intp_alpha = LinearInterpolation.interpolate(lower.alpha, upper.alpha, lower.tv_1t, upper.tv_1t, tv)
      TDist.new(alpha: intp_alpha, df: df, tv_1t: tv, p_cum: (1.0 - alpha))
    end

    def interpolated_by_tv_two_sided(tv, df)
      lower, upper = range_by_tv_two_sided(tv, df)
      intp_alpha = LinearInterpolation.interpolate(lower.alpha, upper.alpha, lower.tv_2t, upper.tv_2t, tv)
      TDist.new(alpha: intp_alpha, df: df, tv_2t: tv, p_cum: (1.0 - alpha))
    end

  end


end
