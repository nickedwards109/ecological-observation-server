require 'rails_helper'

RSpec.describe 'observation requests' do
  it 'responds to a request for all Observations' do
    create_list(:observation, 3)

    get '/api/v1/observations'

    expect(response).to be_success

    observations = JSON.parse(response.body)
    expect(observations.count).to eq(3)

    observation = observations[0]
    expect(observation).to include('id')
    expect(observation).to include('species_id')
    expect(observation).to include('latitude')
    expect(observation).to include('longitude')
    expect(observation).to include('date')
  end

  it 'responds to a request for a single Observation' do
    create(:observation, id: 1)

    get '/api/v1/observations/1'

    expect(response).to be_success

    observation = JSON.parse(response.body)
    expect(observation).to include('id')
    expect(observation).to include('species_id')
    expect(observation).to include('latitude')
    expect(observation).to include('longitude')
    expect(observation).to include('date')
  end

  it 'creates a new Observation record and responds with a 200' do
    create(:species, id: 1)
    initial_observation_count = Observation.all.count

    post '/api/v1/observations?observation[latitude]=43.888470&observation[longitude]=-72.151481&observation[date]=2018-01-13&observation[species_id]=1'

    expect(response).to be_success

    final_observation_count = Observation.all.count
    created_observations_count = final_observation_count - initial_observation_count
    expect(created_observations_count).to eq(1)
  end
end
