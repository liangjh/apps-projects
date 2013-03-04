source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Core libs
gem 'pg'
gem 'json'
gem 'jquery-rails'
gem 'newrelic_rpm' # monitoring
gem 'quiet_assets' # remove asset pipeline requests
gem 'bson'
gem 'bson_ext'
gem 'kaminari' # pagination
gem 'nokogiri' # xml parsing
gem 'yajl-ruby'

# Logging and reporting
gem 'airbrake'
gem 'gabba'

# 3rd party data source connectors
gem 'tire'  # elastic search integration
gem 'flickraw-cached' # flickr client
gem 'dalli' # memcached client

# Auth plugins
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

# Debugging: include debug only for development 
group :development do
  gem 'pry'
  gem 'pry-nav'
end

