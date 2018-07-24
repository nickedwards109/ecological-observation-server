require './lib/authentication.rb'

class AuthenticationController < ApplicationController
  include Authentication
  before_action :require_authentication

  private

  # The default behavior is to respond with a 400
  # That behavior can only be overridden when the request is authenticated
  def require_authentication
    render status: 400 unless authenticated?(request)
  end
end
