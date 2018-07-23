class AuthenticationController < ApplicationController
  before_action :require_authentication

  private

  def require_authentication
    # If an authorization token is included in the HTTP request, grab it
    if request.env["HTTP_AUTHORIZATION"]
      http_auth_token = request.env["HTTP_AUTHORIZATION"].split('Bearer ')[1]
    end

    # The default behavior is to respond with a 400
    # That behavior can only be overridden when the HTTP authorization token matches the actual authorization token
    render status: 400 unless http_auth_token == ENV['AUTH_TOKEN']
  end
end
