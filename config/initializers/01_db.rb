module DBInitializer
  def redis
    @redis ||= Redis.new(
      host: '127.0.0.1',
      port: 6379,
      db: 0,
      reconnect_attempts: 10,
      reconnect_delay: 1,
      reconnect_delay_max: 3.0
    )
  end
end
