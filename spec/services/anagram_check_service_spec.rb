require 'rails_helper'

RSpec.describe AnagramCheckService do

  describe "::all_anagrams?" do
    context "when all are anagrams" do
      it "returns true" do
        words = ["read", "dear", "dare"]

        expect(AnagramCheckService.all_anagrams?(words)).to eq true
      end
    end

    context "when all are anagrams" do
      it "returns false" do
        words = ["read", "dear", "dare", "mate"]

        expect(AnagramCheckService.all_anagrams?(words)).to eq false
      end
    end

    context "when empty" do
      it "returns false" do
        words = []

        expect(AnagramCheckService.all_anagrams?(words)).to eq false
      end
    end

    context "when only one word" do
      it "returns false" do
        words = ["read"]

        expect(AnagramCheckService.all_anagrams?(words)).to eq false
      end
    end

    context "when bad values passed in" do
      it "returns false" do
        words = [1, 2]

        expect(AnagramCheckService.all_anagrams?(words)).to eq false
      end
    end
  end
end
