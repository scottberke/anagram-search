class Api::V1::WordsController < ApplicationController

  def create
    Dictionary.instance.ingest_from_array(params[:words])

    head :created
  end

  def destroy
    if params.has_key?(:word)
      Dictionary.instance.delete_word(params[:word])
    else
      Dictionary.instance.reset_dictionary
    end

    head :no_content
  end

end
