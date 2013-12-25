module ApplicationHelper


  ##
  #  Delegates to number_to_precision for now w/ a fixed percentage
  #  but in the future this can be a custom setting on a user-by-user basis
  def format_precision(number)
    number_with_precision(number, :precision => 4)
  end

end
