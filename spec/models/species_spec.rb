require 'rails_helper'

RSpec.describe Species, type: :model do
  it "has a common name and a scientific name" do
    red_oak = Species.create(
      common_name: "Red Oak",
      scientific_name: "Quercus rubra"
    )

    expect(red_oak).to be_valid
    expect(red_oak.common_name).to eq("Red Oak")
    expect(red_oak.scientific_name).to eq("Quercus rubra")
  end

  it "validates for the presence of a common name and a scientific name" do
    no_common_name = Species.create(
      scientific_name: "Quercus rubra"
    )
    expect(no_common_name).to be_invalid

    no_scientific_name = Species.create(
      common_name: "Red Oak"
    )
    expect(no_scientific_name).to be_invalid
  end
end
