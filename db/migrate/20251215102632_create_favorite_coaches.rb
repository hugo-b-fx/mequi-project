class CreateFavoriteCoaches < ActiveRecord::Migration[7.1]
  def change
    create_table :favorite_coaches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :coach, null: false, foreign_key: true

      t.timestamps
    end
  end
end
