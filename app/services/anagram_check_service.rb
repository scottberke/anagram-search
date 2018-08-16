class AnagramCheckService
  class << self
    def all_anagrams?(words)
      return false if words.empty? || words.size == 1

      key = Array.new(26, 0)

      words[0].chars do |char|
        index = char.downcase.ord % 26
        key[index] += 1
      end

      words[1..-1].map do |word|
        compare_key = Array.new(26, 0)
        word.chars do |char|
          index = char.downcase.ord % 26
          compare_key[index] += 1
        end
        
        return false if key != compare_key
      end

      true
    end
  end
end
