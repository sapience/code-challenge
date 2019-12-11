Dir.glob('./config/initializers/*.rb') { |file| require file }
Dir.glob('./app/workers/*.rb') { |file| require file }
