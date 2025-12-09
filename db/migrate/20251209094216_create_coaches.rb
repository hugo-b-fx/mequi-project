class CreateCoaches < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches do |t|
      t.references :user, null: false, foreign_key: true
      t.string :specialities
      t.string :level
      t.string :location
      t.integer :price_per_session
      t.integer :years_experience
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
