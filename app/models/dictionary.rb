require 'singleton'
require 'set'

class Dictionary
  include Singleton
  attr_accessor :anagrams, :stats

  def initialize()
    @anagrams = {}
    @stats = { min: 0, max: 0, median: 0, average: 0, words_count: 0 }
  end

  def ingest_from_file(path: nil)
    path ||= Rails.root.join("public", "dictionary.txt")
    raise TypeError unless File.extname(path) == '.txt'

    # TODO add error catching
    File.open(path, 'r').each_line do |word|
      add_anagram(word.strip)
    end

    # binding.pry
    # Reading
    # 0.320000   0.310000   0.630000 (  1.128999)
    # 0.320000   0.310000   0.630000 (  1.053605)
    # 0.310000   0.310000   0.620000 (  1.093451)

    # Adding to hash
    # 3.270000   0.110000   3.380000 (  3.462996)
  end

  def ingest_from_array(words)
    words.each do |word|
      add_anagram(word)
    end
  end

  private

  def add_anagram(word)
    key = word.downcase.chars.sort.join
    if self.anagrams.has_key?(key)
      self.anagrams[key].add(word)
    else
      self.anagrams[key] = Set.new [word]
    end
    
    update_stats(word)
  end

  # def ingest_from_file2(path:)
  #   IO.foreach(path) do |word|
  #     add_anagram(word.strip)
  #   end
    # Reading
    # 0.320000   0.300000   0.620000 (  1.013271)
    # 0.290000   0.290000   0.580000 (  0.863266)
    # 0.300000   0.290000   0.590000 (  0.937226)

    # Adding to Hash
    # 3.270000   0.090000   3.360000 (  3.406539)
  # end
  def update_stats(word)
    self.stats[:words_count] += 1

    size = word.size
    if size <= self.stats[:min] || self.stats[:min] == 0
      self.stats[:min] = size
    end

    if size > self.stats[:max]
      self.stats[:max] = size
    end

    # TODO Round average
    self.stats[:average] = (self.stats[:average] * (self.stats[:words_count] - 1)  + size) / self.stats[:words_count].to_f

  end



end
