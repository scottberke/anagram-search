require 'rails_helper'

RSpec.describe Api::V1::AnagramsController, type: :request do

  let(:words) { ["read", "dear", "dare"] }

  describe "GET #show" do
    before(:each) { Singleton.__init__(Dictionary) }

    it "returns http success" do
      get '/anagrams/word.json'

      expect(response).to have_http_status(:success)
    end

    it "fetches anagrams" do
      dictionary = Dictionary.instance
      dictionary.ingest_from_array(words)

      get '/anagrams/read.json'
      body = JSON.parse(response.body)

      expected_anagrams = %w(dare dear)
      expect(body["anagrams"].sort).to eq expected_anagrams.sort
    end

    it "fetches anagrams with limit" do
      dictionary = Dictionary.instance
      dictionary.ingest_from_array(words)

      get '/anagrams/read.json?limit=1'
      body = JSON.parse(response.body)

      expect(body["anagrams"].size).to eq 1
    end

    it "fetches for word with no anagrams" do
      dictionary = Dictionary.instance
      dictionary.ingest_from_array(words)

      get '/anagrams/zyxw.json'
      body = JSON.parse(response.body)

      expect(body["anagrams"]).to be_empty
    end
  end

  describe "GET #check" do
    it "returns http success" do
      get '/anagrams/check'

      expect(response).to have_http_status(:success)
    end

    context "when all words are anagrams" do
      it "checks if all words are anagrams" do
        words = ["read", "dear", "dare"]
        get "/anagrams/check?words=#{words}"

        body = JSON.parse(response.body)

        expect(body["words"]).to eq words
        expect(body["all_anagrams?"]).to eq true
      end
    end

    context "when all words are not anagrams" do
      it "checks if all words are anagrams" do
        words = ["read", "dear", "dare", "mate"]
        get "/anagrams/check?words=#{words}"

        body = JSON.parse(response.body)

        expect(body["words"]).to eq words
        expect(body["all_anagrams?"]).to eq false
      end
    end
  end
end
