class Shorten
  include DBInitializer

  attr_reader :url

  ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.split(//)

  def initialize(url)
    @url = url
  end

  def call
    uniq_id = redis.incr('uniq_id')
    short_url = bijective(uniq_id)
    return short_url if redis.set(short_url, url)
  end

  private

  def bijective(uniq_id)
    return ALPHABET[0] if uniq_id.zero?

    code = ''
    base = 62
    
    while uniq_id.positive?
      code << ALPHABET[uniq_id.modulo(base)]
      uniq_id /= base
    end

    code.reverse
  end
end
