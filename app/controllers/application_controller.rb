class ApplicationController < ActionController::API

  def dict
    Dictionary.instance
  end

end
