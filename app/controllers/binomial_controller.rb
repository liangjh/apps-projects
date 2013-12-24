
##
#  For the binomial distribution
class BinomialController < ApplicationController

  def show

    @n = params[:n]
    @x = params[:x]
    @p = params[:p]

    #  If the form has been explicitly submitted (i.e. user clicked on "go statsly go")
    if submitted_form?

      errors = validate(@n, @x, @p)
      if errors.present?
        flash.now[:error] = errors
      else
        @bin_dist = Distributions::Binomial.by_n_x_p(@n, @x, @p)
      end
    end

  end


  private

  def validate(n, x, p)
    errors = []
    if !n.present? || !x.present? || !p.present?
      errors << "Missing required fields: n, x, or p"
    else
      if x.to_i < 1 || x.to_i >= n.to_i
        errors << "x must be a number between 1 and #{n.to_i - 1}"
      end
    end
    errors
  end

end
