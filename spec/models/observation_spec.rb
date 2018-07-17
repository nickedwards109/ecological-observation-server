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
end
