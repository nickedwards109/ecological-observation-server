class Api::V1::ObservationsController < AuthenticationController
  def index
    observations = ActiveRecord::Base.connection.execute("
      SELECT observations.id,
             observations.latitude,
             observations.longitude,
             observations.date,
             species.common_name AS species_common_name,
             species.scientific_name AS species_scientific_name
      FROM observations
      INNER JOIN species ON observations.species_id = species.id;
      ")
    render json: observations
  end

  def show
    observation_id = params[:id]
    # Prevent SQL injection by ensuring that the id is actually an integer
    sanitized_observation_id = Integer(observation_id)
    render 404 if sanitized_observation_id.class != Fixnum
    observation = ActiveRecord::Base.connection.execute("
      SELECT observations.id,
             observations.latitude,
             observations.longitude,
             observations.date,
             species.common_name AS species_common_name,
             species.scientific_name AS species_scientific_name
      FROM observations
      INNER JOIN species ON observations.species_id = species.id
      WHERE observations.id = #{sanitized_observation_id}
      ")
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
end
