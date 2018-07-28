require './lib/authentication.rb'

class AuthenticationController < ApplicationController
  include Authentication
  before_action :require_authentication

  private

  # The default behavior for a POST is to respond with a 400
  # That behavior can only be overridden when the request is authenticated
  #
  # The data in the database is for public use, so GET requests are not
  # filtered out by requiring authentication
  #
  def require_authentication
    if request.method == "POST"
      render status: 400 unless authenticated?(request)
    end
  end
end
