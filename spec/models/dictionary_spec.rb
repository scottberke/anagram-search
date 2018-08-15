require 'rails_helper'

RSpec.describe Dictionary do

  let(:words) { ["read", "dear", "dare"] }


  def create_dictionary_file(words_array)
    dict = File.open(Dir.pwd + '/test_dictionary.txt', 'w+') do |f|
      words_array.each do |word|
        f.puts word
      end
      f
    end
  end

  describe '.instance' do
    it 'only has one instance' do
      dict_1 = Dictionary.instance
      dict_2 = Dictionary.instance

      expect(dict_1.object_id).to eq dict_2.object_id
    end
  end

  describe 'dictionary attributes' do
    subject { Dictionary.instance }

    it { is_expected.to respond_to :anagrams }
    it { is_expected.to respond_to :stats }
  end

  describe '#ingest_from_file' do
    before(:each) { Singleton.__init__(Dictionary) }

    it 'accepts a file path and populates anagrams' do
      dictionary = Dictionary.instance

      expect(dictionary.anagrams).to be_empty

      dictionary_file = create_dictionary_file(words)
      dictionary.ingest_from_file(path: dictionary_file.path)

      expect(dictionary.anagrams).to_not be_empty
    end

    it 'only accepts txt files' do
      dictionary = Dictionary.instance
      not_text_path = Pathname.new('image.jpg')

      expect {
        dictionary.ingest_from_file(path: not_text_path)
      }.to raise_error(TypeError)
    end
  end

  describe '#ingest_from_array' do
    before(:each) { Singleton.__init__(Dictionary) }

    it 'accepts an array and populates anagrams' do
      dictionary = Dictionary.instance

      expect(dictionary.anagrams).to be_empty

      dictionary.ingest_from_array(words)
      expect(dictionary.anagrams).to_not be_empty
    end
  end

  describe '#anagrams' do
    before(:each) { Singleton.__init__(Dictionary) }

    it 'writes a key as sorted string' do
      dictionary = Dictionary.instance
      expect(dictionary.anagrams).to be_empty

      dictionary.ingest_from_array(words)

      expected_key = words.sample.chars.sort_by(&:downcase).join
      expect(dictionary.anagrams).to have_key expected_key
    end

  end

  describe '#get_anagrams' do
    before(:each) { Singleton.__init__(Dictionary) }

    it 'gets correct anagrams' do
      dictionary = Dictionary.instance
      expect(dictionary.anagrams).to be_empty

      dictionary.ingest_from_array(words)

      word = words.sample
      key = word.chars.sort_by(&:downcase).join
      expected_anagrams = dictionary.anagrams[key] - [ word ]

      expect(dictionary.get_anagrams(word)).to eq expected_anagrams
    end

  end

  describe '#reset_dictionary' do
    before(:each) { Singleton.__init__(Dictionary) }

    it 'resets dictionary' do
      dictionary = Dictionary.instance

      dictionary.ingest_from_array(words)
      expect(dictionary.anagrams).to_not be_empty

      dictionary.reset_dictionary
      expect(dictionary.anagrams).to be_empty
    end

  end

  describe '#delete_word' do
    before(:each) { Singleton.__init__(Dictionary) }

    it 'delets provided anagram' do
      dictionary = Dictionary.instance
      dictionary.ingest_from_array(words)

      delete_word = words[0]
      search_word = words[1]

      expect(dictionary.get_anagrams(search_word)).to include delete_word

      dictionary.delete_word(delete_word)
      expect(dictionary.get_anagrams(search_word)).to_not include delete_word
    end

  end

end
