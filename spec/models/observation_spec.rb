require 'rails_helper'

RSpec.describe Observation, type: :model do
  it "has a latitude, a longitude, and date, and belongs to a species" do
    species = create(:species)

    observation = Observation.create(
      latitude: 43.711919,
      longitude: -72.260772,
      date: "2018-01-13",
      species_id: species.id
    )

    expect(observation).to be_valid
    expect(observation.species).to eq(species)
  end

  it "validates for the presence of latitude, longitude, and date fields" do
    species = create(:species)

    no_latitude_observation = Observation.create(
      longitude: -72.260772,
      date: "2018-01-13",
      species_id: species.id
    )
    expect(no_latitude_observation).to be_invalid

    no_longitude_observation = Observation.create(
      latitude: 43.711919,
      date: "2018-01-13",
      species_id: species.id
    )
    expect(no_longitude_observation).to be_invalid

    no_date_observation = Observation.create(
      latitude: 43.711919,
      longitude: -72.260772,
      species_id: species.id
    )
    expect(no_date_observation).to be_invalid
  end

  it "validates for the presence of a foreign key relation to a Species record" do
    no_species_observation = Observation.create(
      latitude: 43.711919,
      longitude: -72.260772,
      date: "2018-01-13"
    )
    expect(no_species_observation).to be_invalid
  end

  it "validates for the numericality of the latitude and longitude fields" do
    species = create(:species)

    non_numerical_coordinates_observation = Observation.create(
      latitude: "asdf",
      longitude: "asdf",
      date: "2018-01-13",
      species_id: species.id
    )
    expect(non_numerical_coordinates_observation).to be_invalid
  end

  it "rounds the latitude and longitude fields to a scale of 6" do
    species = create(:species)

    too_long_coordinates_observation = Observation.create(
      latitude: 12.345678901,
      longitude: -12.345678901,
      date: "2018-01-13",
      species_id: species.id
    )

    expect(too_long_coordinates_observation.latitude).not_to eq(12.345678901)
    expect(too_long_coordinates_observation.latitude).to eq(12.345679)

    expect(too_long_coordinates_observation.longitude).not_to eq(-12.345678901)
    expect(too_long_coordinates_observation.longitude).to eq(-12.345679)
  end
end
