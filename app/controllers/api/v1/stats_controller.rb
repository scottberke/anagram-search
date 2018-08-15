class Api::V1::StatsController < ApplicationController

  def stats
    render json: { stats: dict.stats }
  end

end
