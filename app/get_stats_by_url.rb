class GetStatsByUrl
  include DBInitializer

  attr_reader :page

  KEYS_TO_GET = %w[r u]

  def initialize(page = 0)
    @page = page.to_i
  end

  def call
    answer = redis.scan(page, match: 's:*', count: 1000)
    return unless answer

    page_to_return = answer[0]
    keys = answer[1]
    data = transform_responce(keys)

    json_data(page_to_return, data)
  end

  private

  def transform_responce(keys)
    keys.each_with_object({}) do |key, memo|
      short_url = key[2..-1]
      long_url = redis.get(short_url)

      memo[short_url] = { short_url: short_url, long_url: long_url }

      values = redis.hmget(key, KEYS_TO_GET)

      KEYS_TO_GET.each.with_index do |_key, index|
        memo[short_url].merge!(KEYS_TO_GET[index] => values[index])
      end
    end
  end

  def json_data(page, data)
    { 
      data: data,
      page: page
    }.to_json
  end
end
