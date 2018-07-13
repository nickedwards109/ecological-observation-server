class Species < ApplicationRecord
  validates :common_name, :scientific_name, presence: true
end
