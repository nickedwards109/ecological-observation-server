class Api::V1::ObservationsController < ApplicationController
  def index
    observations = Observation.all
    render json: observations
  end

  def show
    observation = Observation.find(params[:id])
    render json: observation
  end
end
