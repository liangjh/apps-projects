class ZdistController < ApplicationController

  def show

    @solve_alpha = params[:solve_alpha].present? ? params[:solve_alpha] == "true" : false
    @alpha = params[:alpha].present? ? params[:alpha].to_f : nil
    @zv    = params[:zv].present? ? params[:zv].to_f : nil

    if @solve_alpha
      @alpha = nil
    else
      @zv = nil
    end

    if submitted_form?
      errors = Distributions::Z.validate(@alpha, @zv)
      if errors.present?
        flash.now[:error] = errors
      else
        @z_dist = Distributions::Z.solve(@alpha, @zv)
      end
    end
  end

end
