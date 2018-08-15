class Api::V1::StatsController < ApplicationController

  def stats
    render json: { stats: Dictionary.instance.stats }
  end

end
