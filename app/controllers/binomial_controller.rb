
##
#  For the binomial distribution
class BinomialController < ApplicationController

  def show

    @n = params[:n].to_i
    @p = params[:p].to_f
    @x = params[:x].present? ? params[:x].to_i : nil

    #  If the form has been explicitly submitted (i.e. user clicked on "go statsly go")
    if submitted_form?
      errors = Distributions::Binomial.validate(@n, @x, @p)
      if errors.present?
        flash.now[:error] = errors
      else
        @bin_dist = Distributions::Binomial.by_n_x_p(@n, @x, @p)
      end
    end

  end


end
