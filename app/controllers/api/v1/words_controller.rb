class Api::V1::WordsController < ApplicationController

  def create
    dict.ingest_from_array(params[:words])

    head :created
  end

  def destroy
    if params.has_key?(:word)
      key = params[:word].downcase.chars.sort.join
      dict.anagrams[key].delete(params[:word]) if dict.anagrams.has_key?(key)
    else
      dict.anagrams = Hash.new
    end

    head :no_content
  end

end
