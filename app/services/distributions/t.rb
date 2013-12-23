require 'linear_interpolation'

module Distribution
  class T

    class << self

      def dfs; @dfs ||= TDist.select(:df).order(:df).group(:df).map(&:df); end
      def min_df; dfs.first; end
      def max_df; dfs.last; end

      def alphas; @alphas ||= TDist.select(:alpha).order(:alpha).group(:alpha).map(&:alpha); end
      def min_alpha; alphas.first; end
      def max_alpha; alphas.last; end

      def by_alpha_and_df(alpha, df)
        tdist = TDist.find_by_alpha_and_df(alpha, df)
        tdist = interpolated_by_alpha(alpha, df) if tdist.nil?
        tdist
      end

      def by_tv_one_sided_and_df(tv, df)
        TDist.find_by_tv_1t_and_df(tv, df)
      end

      def by_tv_two_sided_and_df(tv, df)
        TDist.find_by_tv_2t_and_df(tv, df)
      end

      def interpolated_by_alpha(alpha, df)
        lower, upper = TDist.range_by_alpha(alpha, df)
        return nil if lower.nil? || upper.nil?
        intp_tv_one = LinearInterpolation.interpolate(lower.tv_1t, upper.tv_1t, lower.alpha, upper.alpha, alpha)
        intp_tv_two = LinearInterpolation.interpolate(lower.tv_1t, upper.tv_2t, lower.alpha, upper.alpha, alpha)
        td = TDist.new(alpha: alpha, df: df, tv_1t: intp_tv_one, tv_2t: intp_tv_two, p_cum: (1.0 - alpha))
        td.range = [lower, upper]
        td
      end

      def interpolated_by_tv_one_sided(tv, df)
        lower, upper = TDist.range_by_tv_one_sided(tv, df)
        return nil if lower.nil? || upper.nil?
        intp_alpha = LinearInterpolation.interpolate(lower.alpha, upper.alpha, lower.tv_1t, upper.tv_1t, tv)
        td = TDist.new(alpha: intp_alpha, df: df, tv_1t: tv, p_cum: (1.0 - alpha))
        td.range = [lower, upper]
        td
      end

      def interpolated_by_tv_two_sided(tv, df)
        lower, upper = TDist.range_by_tv_two_sided(tv, df)
        return nil if lower.nil? || upper.nil?
        intp_alpha = LinearInterpolation.interpolate(lower.alpha, upper.alpha, lower.tv_2t, upper.tv_2t, tv)
        td = TDist.new(alpha: intp_alpha, df: df, tv_2t: tv, p_cum: (1.0 - alpha))
        td.range = [lower, upper]
        td
      end
    end

  end
end
