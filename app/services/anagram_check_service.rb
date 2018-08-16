class AnagramCheckService
  class << self
    def all_anagrams?(words)
      return false if words.empty? || words.size == 1

      begin
        key = build_key_from_word(words[0])

        words[1..-1].map do |word|
          compare_key = build_key_from_word(word)

          return false if key != compare_key
        end

      rescue NoMethodError => e
        puts "#{e.class}: #{e.message}"

        return false
      end

      true
    end

    private

    def build_key_from_word(word)
      key = Array.new(26, 0)
      word.chars do |char|
        index = char.downcase.ord % 26
        key[index] += 1
      end

      key
    end

  end
end
