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
end
