
##
#  Set the elasticsearch URL to the bonsai URL
#  only if we're not in the development environment (in which case use the localhost config)
if Rails.env == "development"
  puts "Tire :: Setting elasticsearch destination to: localhost"
  Tire.configure do
    # set destination to localhost, and set logging / debug
    url "http://localhost:9200"
    logger 'elasticsearch.log', :level => 'debug'
  end
else
  Tire.configure do
    puts "Tire :: Setting elasticsearch destination to: #{ENV['BONSAI_URL']}"
    url ENV['BONSAI_URL']
  end
end

