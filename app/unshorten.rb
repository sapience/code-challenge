class Unshorten
  include DBInitializer

  attr_reader :short_code

  def initialize(code)
    @short_code = code
  end

  def call
    redis.get(short_code)
  end
end
