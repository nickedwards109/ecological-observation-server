class Observation < ApplicationRecord
  belongs_to :species
  validates :latitude, :longitude, :date, presence: true
  validates :latitude, :longitude, numericality: true
end
