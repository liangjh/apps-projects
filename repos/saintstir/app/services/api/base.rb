

##
#  This is the base API module
#  Contains a number of common functionalities that are utilized across the API
#
module Api

  module Base

    ##
    #  Returns false if any of the required options are not in the options hash
    def validate_options(options = {}, required_options = [])
      required_options.each do |opt|
        if (!options.has_key?(opt))
          return false
        end
      end
      true
    end

    def check_options(options = {}, required_options = [])
      throw Exception.new("") if (!validate_options(options, required_options))
    end

  end

end
