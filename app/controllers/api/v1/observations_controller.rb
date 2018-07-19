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
    observation = Observation.new(observation_params)
    if observation.save
      render status: 200
    else
      render status: 400
    end
  end

  def observation_params
    params.require(:observation).permit(:latitude, :longitude, :date, :species_id)
  end
end
