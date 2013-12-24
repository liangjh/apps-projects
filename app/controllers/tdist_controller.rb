class TdistController < ApplicationController

  def show

    @solve_alpha = params[:solve_alpha].present? ? params[:solve_alpha] == "true" : false
    @alpha = params[:alpha].present? ? params[:alpha].to_f : nil
    @tv    = params[:tv].present? ? params[:tv].to_f : nil
    @df    = params[:df].to_i

    ##  Based on what we're solving, set solve var to nil
    if @solve_alpha
      @alpha = nil
    else
      @tv = nil
    end

    if submitted_form?
      errors = Distributions::T.validate(@alpha, @tv, @df)
      if errors.present?
        flash.now[:error] = errors
      else
        @t_dist = Distributions::T.solve(@alpha, @tv, @df)
      end
    end

  end

end
