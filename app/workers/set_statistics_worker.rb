class SetStatisticsWorker
  include DBInitializer
  include Sidekiq::Worker

  def perform(short_code, ip)
    AdvancedStatisticsWorker.perform_async(ip)
    
    entry_count = redis.hincrby("s:#{short_code}", "ip:#{ip}", 1)
    redis.pipelined do
      redis.hincrby("s:#{short_code}", 'r', 1)
      redis.hincrby('global-statistics', 'total-redirections', 1)
      if entry_count == 1
        redis.hincrby("s:#{short_code}", 'u', 1)
        redis.hincrby('global-statistics', 'unic-redirections', 1)
      end
    end
  end
end
