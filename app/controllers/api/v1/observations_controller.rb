class Api::V1::ObservationsController < ApplicationController
  def index
    observations = Observation.all
    render json: observations
  end

  def show
    observation = Observation.find(params[:id])
    render json: observation
  end

  def create
    Observation.create(observation_params)
    render status: 200
  end

  def observation_params
    params.require(:observation).permit(:latitude, :longitude, :date, :species_id)
  end
end
