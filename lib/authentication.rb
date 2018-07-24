module Authentication
  def authenticated?(request)
    # If an authorization token is included in the HTTP request, grab it
    if request.env["HTTP_AUTHORIZATION"]
      http_auth_token = request.env["HTTP_AUTHORIZATION"].split('Bearer ')[1]
    end

    # Does the HTTP authorization token matches the actual authorization token?
    # Return a boolean
    http_auth_token == ENV['AUTH_TOKEN']
  end
end
