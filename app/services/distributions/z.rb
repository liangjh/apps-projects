require 'linear_interpolation'

module Distributions
  class Z
    class << self

      # List of all supported z values (used for selection list
      def zvalues; @zvalues ||= ZDist.select(:zv).order(:zv).group(:zv).map(&:zv); end

      def min_zvalue; zvalues.first; end
      def max_zvalue; zvalues.last; end
      def min_alpha; @min_alpha ||= ZDist.minimum(:p_lt_zv); end
      def max_alpha; @max_alpha ||= ZDist.maximum(:p_lt_zv); end

      def by_zvalue(zvalue)
        zdist = ZDist.find_by_zv(zvalue)
        zdist = interpolated_by_zvalue(zvalue) if zdist.nil?
        zdist
      end

      def by_alpha(alpha)
        interpolated_by_alpha(alpha)
      end

      def interpolated_by_zvalue(zvalue)
        lower, upper = ZDist.range_by_zvalue(zvalue)
        return nil if lower.nil? || upper.nil?
        intp_p_lt_zv = LinearInterpolation.interpolate(lower.p_lt_zv, upper.p_lt_zv, lower.zv, upper.zv, zvalue)
        intp_p_gt_zv = LinearInterpolation.interpolate(lower.p_gt_zv, upper.p_gt_zv, lower.zv, upper.zv, zvalue)
        zd = ZDist.new(zv: zvalue, p_lt_zv: intp_p_lt_zv, p_gt_zv: intp_p_gt_zv)
        zd.range = [lower, upper]
        zd
      end

      def interpolated_by_alpha(alpha)
        lower, upper = ZDist.range_by_alpha(alpha)
        return nil if lower.nil? || upper.nil?
        intp_zv = LinearInterpolation.interpolate(lower.zv, upper.zv, lower.p_lt_zv, upper.p_lt_zv, alpha)
        zd = ZDist.new(zv: intp_zv, p_lt_zv: alpha, p_gt_zv: (1.0 - alpha))
        zd.range = [lower, upper]
        zd
      end

    end
  end
end

