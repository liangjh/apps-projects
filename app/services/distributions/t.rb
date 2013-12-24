require 'linear_interpolation'

module Distributions
  class T

    class << self

      def dfs; @dfs ||= TDist.select(:df).order(:df).group(:df).map(&:df); end
      def min_df; dfs.first; end
      def max_df; dfs.last; end

      def alphas; @alphas ||= TDist.select(:alpha).order(:alpha).group(:alpha).map(&:alpha); end
      def min_alpha; alphas.first; end
      def max_alpha; alphas.last; end


      def solve(alpha, tv, df)
        if !df.present? || (!alpha.present? && !tv.present?)
          nil
        else
          if alpha.present? && !tv.present?
            by_alpha_and_df(alpha, df)
          elsif !alpha.present? && tv.present?
            by_tv_one_sided_and_df(tv, df)
          else
            nil
          end
        end
      end

      def validate(alpha, tv, df)
        errors = []
        errors << "df is required" if !df.present?
        errors << "At least alpha or tvalue are required" if !alpha.present? && !tv.present?
        errors << "Alpha is out of range" if alpha.present? && (alpha < min_alpha || alpha > max_alpha)
      end

      def by_alpha_and_df(alpha, df)
        tdist = TDist.find_by_alpha_and_df(alpha, df)
        tdist = interpolated_by_alpha(alpha, df) if tdist.nil?
        tdist
      end

      def by_tv_one_sided_and_df(tv, df)
        TDist.find_by_tv_1t_and_df(tv, df)
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

      ##
      #  If you're given a t-value, you solve w/ it one-sided and
      #  extrapolate to 2*alpha in the event of solving for a 2-sided distribution
      def interpolated_by_tv_one_sided(tv, df)
        lower, upper = TDist.range_by_tv_one_sided(tv, df)
        return nil if lower.nil? || upper.nil?
        intp_alpha = LinearInterpolation.interpolate(lower.alpha, upper.alpha, lower.tv_1t, upper.tv_1t, tv)
        td = TDist.new(alpha: intp_alpha, df: df, tv_1t: tv, p_cum: (1.0 - alpha))
        td.range = [lower, upper]
        td
      end

    end

  end
end
