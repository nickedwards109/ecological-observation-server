require 'rails_helper'

RSpec.describe 'observation requests' do
  before(:each) do
    ENV['AUTH_TOKEN'] = '08545a3bcc797767d52fbf5c3459ebe2ff0178e88588f9415bc4560e16221c45658dd269d17340a98a9ed1875950873c7e7c62b2a844bcc906edab62c9adddf0'
  end

  it 'responds to an authorized request for all Observations with a 200' do
    create_list(:observation, 3)

    get '/api/v1/observations',
      params: nil,
      headers: { Authorization: 'Bearer 08545a3bcc797767d52fbf5c3459ebe2ff0178e88588f9415bc4560e16221c45658dd269d17340a98a9ed1875950873c7e7c62b2a844bcc906edab62c9adddf0' }

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

  it 'responds to unauthorized requests for all Observations with a 400' do
    create_list(:observation, 3)

    # Request with an authorization header that is properly structured but has the wrong authorization token
    get '/api/v1/observations',
      params: nil,
      headers: { Authorization: 'Bearer asdf' }
    expect(response).to have_http_status(400)
    expect(response.body).to be_blank

    # Request with an authorization header that has the correct authorization token but is improperly structured
    get '/api/v1/observations',
      params: nil,
      headers: { Authorization: 'Bearerr 08545a3bcc797767d52fbf5c3459ebe2ff0178e88588f9415bc4560e16221c45658dd269d17340a98a9ed1875950873c7e7c62b2a844bcc906edab62c9adddf0' }
    expect(response).to have_http_status(400)
    expect(response.body).to be_blank

    # Request with no authorization header
    get '/api/v1/observations'
    expect(response).to have_http_status(400)
    expect(response.body).to be_blank
  end

  it 'responds to an authorized request for a single Observation with a 200' do
    create(:observation, id: 1)

    get '/api/v1/observations/1',
      params: nil,
      headers: { Authorization: 'Bearer 08545a3bcc797767d52fbf5c3459ebe2ff0178e88588f9415bc4560e16221c45658dd269d17340a98a9ed1875950873c7e7c62b2a844bcc906edab62c9adddf0' }

    expect(response).to have_http_status(200)

    observation = JSON.parse(response.body)
    expect(observation).to include('id')
    expect(observation).to include('species_id')
    expect(observation).to include('latitude')
    expect(observation).to include('longitude')
    expect(observation).to include('date')
  end

  it 'responds to unauthorized requests for a single Observation with a 400' do
    create(:observation, id: 1)

    # Request with an authorization header that is properly structured but has the wrong authorization token
    get '/api/v1/observations/1',
      params: nil,
      headers: { Authorization: 'Bearer asdf' }
    expect(response).to have_http_status(400)
    expect(response.body).to be_blank

    # Request with an authorization header that has the correct authorization token but is improperly structured
    get '/api/v1/observations/1',
      params: nil,
      headers: { Authorization: 'Bearerr 08545a3bcc797767d52fbf5c3459ebe2ff0178e88588f9415bc4560e16221c45658dd269d17340a98a9ed1875950873c7e7c62b2a844bcc906edab62c9adddf0' }
    expect(response).to have_http_status(400)
    expect(response.body).to be_blank

    # Request with no authorization header
    get '/api/v1/observations/1'
    expect(response).to have_http_status(400)
    expect(response.body).to be_blank
  end

  it 'responds to an authorized request to create a new Observation record with a 200' do
    create(:species, id: 1)

    initial_observation_count = Observation.all.count

    post '/api/v1/observations',
      params: {
        observation: {
          latitude: 43.888470,
          longitude: -72.151481,
          date: '2018-01-13',
          species_id: 1
        }
      },
      headers: { Authorization: 'Bearer 08545a3bcc797767d52fbf5c3459ebe2ff0178e88588f9415bc4560e16221c45658dd269d17340a98a9ed1875950873c7e7c62b2a844bcc906edab62c9adddf0' }

    expect(response).to have_http_status(200)

    final_observation_count = Observation.all.count
    created_observations_count = final_observation_count - initial_observation_count
    expect(created_observations_count).to eq(1)
  end

  it 'responds to an unauthorized request to create a new Observation record with a 400' do
    create(:species, id: 1)

    initial_observation_count = Observation.all.count

    # Request with an authorization header that is properly structured but has the wrong authorization token
    post '/api/v1/observations',
      params: {
        observation: {
          latitude: 43.888470,
          longitude: -72.151481,
          date: '2018-01-13',
          species_id: 1
        }
      },
      headers: { Authorization: 'Bearer asdf' }
    expect(response).to have_http_status(400)
    expect(response.body).to be_blank

    # Request with an authorization header that has the correct authorization token but is improperly structured
    post '/api/v1/observations',
      params: {
        observation: {
          latitude: 43.888470,
          longitude: -72.151481,
          date: '2018-01-13',
          species_id: 1
        }
      },
      headers: { Authorization: 'Bearerr 08545a3bcc797767d52fbf5c3459ebe2ff0178e88588f9415bc4560e16221c45658dd269d17340a98a9ed1875950873c7e7c62b2a844bcc906edab62c9adddf0' }
    expect(response).to have_http_status(400)
    expect(response.body).to be_blank

    # Request with no authorization header
    post '/api/v1/observations',
      params: {
        observation: {
          latitude: 43.888470,
          longitude: -72.151481,
          date: '2018-01-13',
          species_id: 1
        }
      }
    expect(response).to have_http_status(400)
    expect(response.body).to be_blank


    final_observation_count = Observation.all.count
    created_observations_count = final_observation_count - initial_observation_count
    expect(created_observations_count).to eq(0)
  end

  it 'does not create an invalid Observation record, and responds with a 400' do
    create(:species, id: 1)
    initial_observation_count = Observation.all.count

    # Send a POST request with a query string including invalid latitude and longitude
    post '/api/v1/observations',
      params: {
        observation: {
        latitude: "asdf",
        longitude: "asdf",
        date: '2018-01-13',
        species_id: 1
      }
    },
    headers: { Authorization: 'Bearer 08545a3bcc797767d52fbf5c3459ebe2ff0178e88588f9415bc4560e16221c45658dd269d17340a98a9ed1875950873c7e7c62b2a844bcc906edab62c9adddf0' }

    expect(response).to have_http_status(400)

    final_observation_count = Observation.all.count
    created_observations_count = final_observation_count - initial_observation_count
    expect(created_observations_count).to eq(0)
  end
end
