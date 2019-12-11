require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

Dir.glob('./config/initializers/*.rb') { |file| require file }

require('./config/sinatra')

Dir.glob('./app/**/*.rb') { |file| require file }

module RSpecMixin
  include Rack::Test::Methods
  def app() described_class end
end

RSpec.configure do |c|
  c.include RSpecMixin
  c.formatter = :documentation
end
