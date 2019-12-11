class GetStatistics
  include DBInitializer

  def call
    redirections = redis.hgetall('global-statistics')
    countries = redis.hgetall('global-statistics:country')
    total_countries = countries
                      .values
                      .reduce(0) { |sum, value| sum + value.to_i }

    countries.transform_values! { |value| value.to_i * 100 / total_countries }

    json_data(redirections, countries)
  end

  private

  def json_data(redirections, countries)
    {
      data: {
        redirections: redirections,
        countries: countries
      }
    }.to_json
  end
end
