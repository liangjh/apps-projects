require 'linear_interpolation'

module Distributions
  class Binomial

    class << self

      def ns
        @ns ||= BinomialDist.select(:n_trials).order(:n_trials).group(:n_trials).map(&:n_trials)
      end

      def ps
        @ps ||= BinomialDist.select(:p_population).order(:p_population).group(:p_population).map(&:p_population)
      end

      def min_ns; ns.first; end
      def max_ns; ns.last; end
      def min_ps; ps.first; end
      def max_ps; ps.last; end

      # Returns array of xs, given an n value
      def xs(n)
        (0..n-1).to_a
      end

      ##
      #  Returns distribution (cum and point),
      #  (given n, x, and p)
      def by_n_p_x(n, p, x)
        bin_dist = BinomialDist.find_by_n_trials_and_p_population_and_x_success(n, p, x)
        bin_dist.range = BinomialDist.range_by_x_success(n, p, x)
        bin_dist
      end


      def validate(n, p, x)
        errors = []
        if !n.present? || !x.present? || !p.present?
          errors << "Missing required fields: n, x, or p"
        else
          if x < 1 || x >= n
            errors << "x must be a number between 1 and #{n.to_i - 1}"
          end
        end
        errors
      end

    end

  end
end
