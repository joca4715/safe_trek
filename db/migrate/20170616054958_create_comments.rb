class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :commentable_id
      t.string :commentable_type
      t.string :author
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
