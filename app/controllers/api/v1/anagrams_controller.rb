class Api::V1::AnagramsController < ApplicationController

  def show
    dict = Dictionary.instance
    anagrams = dict.get_anagrams(params[:word])

    limit = params.fetch(:limit, anagrams.size)
    render json: { anagrams: anagrams.first(limit.to_i) }
  end

end
