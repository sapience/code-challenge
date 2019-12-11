Dir.glob('./config/initializers/*.rb') { |file| require file }

require('./config/sinatra')

Dir.glob('./app/**/*.rb') { |file| require file }

run ApplicationController
