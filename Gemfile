source 'https://rubygems.org'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-cross_origin'

group :production, :development do
  gem 'thin'
  gem 'redis'
  gem 'hiredis'
  gem 'sidekiq'
  gem 'maxminddb'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
end
