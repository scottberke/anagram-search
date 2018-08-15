class Api::V1::AnagramsController < ApplicationController
  def show
    key = params[:word].downcase.chars.sort.join

    if dict.anagrams.has_key?(key)
      anagrams = dict.anagrams[key] - [ params[:word] ]
    else
      anagrams = []
    end

    limit = params.fetch(:limit, anagrams.size)
    render json: { anagrams: anagrams.first(limit.to_i) }
  end

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

  def stats
    render json: { stats: dict.stats }
  end

  def show_most

  end


end
