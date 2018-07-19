class Api::V1::ObservationsController < ApplicationController
  before_action :require_authentication

  def index
    observations = Observation.all
    render json: observations
  end

  def show
    observation = Observation.find(params[:id])
    render json: observation
  end

  def create
    observation = Observation.new(observation_params)
    if observation.save
      render status: 200
    else
      render status: 400
    end
  end

  private

    def observation_params
      params.require(:observation).permit(:latitude, :longitude, :date, :species_id)
    end

    def require_authentication
      # Get the authorization token from the HTTP request
      http_auth_token = request.env["HTTP_AUTHORIZATION"].split('Bearer ')[1]

      # Verify whether the token from the HTTP request matches the actual token
      if http_auth_token != ENV['AUTH_TOKEN']
        render status: 400
      end
    end
end
