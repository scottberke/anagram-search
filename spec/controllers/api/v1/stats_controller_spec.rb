require 'rails_helper'

RSpec.describe Api::V1::StatsController, type: :request do

  describe "GET #stats" do
    before(:each) { Singleton.__init__(Dictionary) }

    it "returns http success" do
      get '/stats.json'

      expect(response).to have_http_status(:success)
    end

    it "fetches stats" do
      words = ["read", "dear", "dare"]
      dictionary = Dictionary.instance
      dictionary.ingest_from_array(words)

      get '/stats.json'

      body = JSON.parse(response.body)
      stats = body.fetch('stats')

      expect(stats["min"]).to eq words.sample.size
      expect(stats["max"]).to eq words.sample.size
      expect(stats["average"]).to eq words.sample.size.to_f
      expect(stats["words_count"]).to eq words.size
    end

  end



end
