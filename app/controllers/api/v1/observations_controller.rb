class Api::V1::ObservationsController < ApplicationController
  def index
    observations = Observation.all
    render json: observations
  end
end
