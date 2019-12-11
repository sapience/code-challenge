RSpec.describe ApplicationController do
  describe 'get /global-statistics' do
    it 'return 200' do
      get '/api/global-statistics'
      expect(last_response.status).to eq 200
    end
  end

  describe 'post /shorten' do
    let(:base_url) { '/api/shorten' }
    
    it 'return 200 if request correct' do
      data = { 'url' => 'http://some-long-url.com' }
      post base_url, data.to_json, "CONTENT_TYPE" => "application/json"
      expect(last_response.status).to eq 200
    end

    it 'return 400 if no url given' do
      data = { 'url' => '' }
      post base_url, data.to_json, "CONTENT_TYPE" => "application/json"
      expect(last_response.status).to eq 400
    end

    it 'return 400 if wrong protocol' do
      data = { 'url' => 'mailto://some-long-url.com' }
      post base_url, data.to_json, "CONTENT_TYPE" => "application/json"
      expect(last_response.status).to eq 400
    end
  end
end
