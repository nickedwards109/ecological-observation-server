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
      # If an authorization token is included in the HTTP request, grab it
      if request.env["HTTP_AUTHORIZATION"]
        http_auth_token = request.env["HTTP_AUTHORIZATION"].split('Bearer ')[1]
      end

      # The default behavior is to respond with a 400
      # That behavior can only be overridden when the HTTP authorization token matches the actual authorization token
      render status: 400 unless http_auth_token == ENV['AUTH_TOKEN']
    end
end
