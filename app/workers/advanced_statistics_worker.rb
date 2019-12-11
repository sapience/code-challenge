class AdvancedStatisticsWorker
  include DBInitializer
  include Sidekiq::Worker
  include IPLookupInitializer

  def perform(ip)
    result = ip_service.lookup(ip)
    return unless result.found?

    country = result.country.name
    return if country.empty?

    redis.hincrby('global-statistics:country', country, 1)
  end
end
