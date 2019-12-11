class ApplicationController < Sinatra::Base
  register Sinatra::Namespace

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
    content_type :json
  end

  options '*' do
    response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
    response.headers['Access-Control-Allow-Origin'] = '*'
    200
  end

  namespace '/api' do
    post '/shorten' do
      request.body.rewind
      data = JSON.parse request.body.read
      url = data['url']
      halt([400, { error: 'Url is empty' }.to_json]) if url.nil? || url.empty?

      halt([400, { error: 'Url must be inputed with http:// or https:// in front' }.to_json]) unless url =~ /\A#{URI.regexp(['http', 'https'])}\z/

      short_url = Shorten.new(url).call
      url_to_return = "#{request.scheme}://#{request.host}:#{request.port}/#{short_url}"

      if short_url
        [200, { url: url_to_return }.to_json]
      else
        halt 500
      end
    end

    get '/global-statistics' do
      data = GetStatistics.new.call
      [200, data]
    end

    get '/stats-by-url/:page?' do |page|

      data = GetStatsByUrl.new(page).call
      [200, data]
    end
  end

  get %r{/([A-Za-z0-9]+)} do
    short_url = params['captures'][0]
    long_url = Unshorten.new(short_url).call
    halt([500, "I don't know this url"]) unless long_url

    SetStatisticsWorker.perform_async(short_url, request.ip)
    redirect long_url, 301
  end
end
