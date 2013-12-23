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


      ##
      #  Returns distribution (cum and point),
      #  (given n, x, and p)
      def by_n_x_p(n, x, p)
        BinomialDist.find_by_n_trials_x_success_and_p_population(n, x, p)
      end

    end

  end
end
