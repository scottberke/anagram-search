class Api::V1::AnagramsController < ApplicationController

  def show
    dict = Dictionary.instance
    anagrams = dict.get_anagrams(params[:word])

    limit = params.fetch(:limit, anagrams.size)
    render json: { anagrams: anagrams.first(limit.to_i) }
  end

  def check
    words = JSON.parse(params.fetch(:words, [].to_s))
    result = AnagramCheckService.all_anagrams?(words)
    
    render json: { words: words, all_anagrams?: result }
  end
end
