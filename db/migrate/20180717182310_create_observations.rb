class CreateObservations < ActiveRecord::Migration[5.2]
  def change
    create_table :observations do |t|
      t.decimal :latitude, {precision: 10, scale: 6}
      t.decimal :longitude, {precision: 10, scale: 6}
      t.date :date
      t.references :species, foreign_key: true

      t.timestamps
    end
  end
end
