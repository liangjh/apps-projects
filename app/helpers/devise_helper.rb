

#// We're going to override the devise helper method that displays
#// error message, to display plain text.  There really should be no formatting here.
module DeviseHelper


  #//  make this implementation VERY simple - just return a joined string of all messages
  def devise_error_messages!
    return nil if resource.errors.empty?
    resource.errors.full_messages.join(", ")
  end

end

