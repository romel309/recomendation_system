class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.references :user, index: true, foreign_key: true
      t.references :movie, index: true, foreign_key: true
      t.integer :rating

      t.timestamps null: false
    end
  end
end
