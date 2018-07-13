class CreateSpecies < ActiveRecord::Migration[5.2]
  def change
    create_table :species do |t|
      t.string :common_name
      t.string :scientific_name

      t.timestamps
    end
  end
end
