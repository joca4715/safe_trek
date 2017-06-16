class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :address
      t.boolean :gmaps
      t.string :name
      t.float :rating
      t.decimal :latitude
      t.decimal :longitude
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
