require 'rails_helper'

RSpec.describe 'observation requests' do
  it 'responds to a request for all Observations' do
    create_list(:observation, 3)

    get '/api/v1/observations'

    expect(response).to have_http_status(200)

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

    expect(response).to have_http_status(200)

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

    post '/api/v1/observations', params: {
                                   observation: {
                                     latitude: 43.888470,
                                     longitude: -72.151481,
                                     date: '2018-01-13',
                                     species_id: 1
                                    }
                                  }

    expect(response).to have_http_status(200)

    final_observation_count = Observation.all.count
    created_observations_count = final_observation_count - initial_observation_count
    expect(created_observations_count).to eq(1)
  end

  it 'does not create an invalid Observation record, and responds with a 400' do
    create(:species, id: 1)
    initial_observation_count = Observation.all.count

    # Send a POST request with a query string including invalid latitude and longitude
    post '/api/v1/observations', params: {
                                   observation: {
                                     latitude: "asdf",
                                     longitude: "asdf",
                                     date: '2018-01-13',
                                     species_id: 1
                                    }
                                  }

    expect(response).to have_http_status(400)

    final_observation_count = Observation.all.count
    created_observations_count = final_observation_count - initial_observation_count
    expect(created_observations_count).to eq(0)
  end
end
