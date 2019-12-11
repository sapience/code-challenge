require('maxminddb')

module IPLookupInitializer
  def ip_service
    @ip_service ||= MaxMindDB.new('./lib/GeoLite2-Country.mmdb')
  end
end
