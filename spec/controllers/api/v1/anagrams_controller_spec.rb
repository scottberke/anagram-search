require 'rails_helper'

RSpec.describe Api::V1::AnagramsController, type: :request do

  let(:words) { ["read", "dear", "dare"] }

  describe "POST #create" do
    before(:each) { Singleton.__init__(Dictionary) }

    it "adds words to dictionary" do
      dictionary = Dictionary.instance
      expect(dictionary.anagrams).to be_empty

      post '/words.json', params: {"words" => words }

      key = words.sample.chars.sort_by(&:downcase).join
      expect(dictionary.anagrams).to have_key key
      expect(dictionary.anagrams[key].sort).to eq words.sort
    end

  end


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

  describe 'DELETE #destroy' do
    before(:each) { Singleton.__init__(Dictionary) }

    context 'DELETE /words.json' do
      it "returns http no content" do
        delete '/words.json'

        expect(response).to have_http_status(:no_content)
      end

      it "deletes all words" do
        dictionary = Dictionary.instance
        dictionary.ingest_from_array(words)

        expect(dictionary.anagrams).to_not be_empty

        delete '/words.json'

        expect(dictionary.anagrams).to be_empty
      end

      context 'DELETE /words/read.json' do
        it "returns http no content" do
          delete '/words/read.json'

          expect(response).to have_http_status(:no_content)
        end

        it "deletes a single word" do
          dictionary = Dictionary.instance
          dictionary.ingest_from_array(words)

          random_word = words.sample
          anagram_key = random_word.chars.sort_by(&:downcase).join

          expect(dictionary.anagrams).to have_key(anagram_key)
          expect(dictionary.anagrams[anagram_key]).to include(random_word)

          delete "/words/#{random_word}.json"

          expect(dictionary.anagrams[anagram_key]).to_not include(random_word)
        end

      end
    end
  end

end
