
##
#  Set the elasticsearch URL to the bonsai URL
#  only if we're not in the development environment (in which case use the localhost config)
if Rails.env == "development"
  Tire.configure do
    puts "Tire :: Setting elasticsearch destination to: localhost"
    url "http://localhost:9200"
    # Tire.configure { logger 'log/elasticsearch.log' }
  end
else
  Tire.configure do
    puts "Tire :: Setting elasticsearch destination to: #{ENV['BONSAI_URL']}"
    url ENV['BONSAI_URL']
  end
end

