class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :current_city
      t.string :current_state
      t.string :current_country
      t.text :bio

      t.timestamps
    end
  end
end
