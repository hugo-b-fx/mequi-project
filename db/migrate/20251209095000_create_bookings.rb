class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :horse, null: false, foreign_key: true
      t.references :coach, null: false, foreign_key: true
      t.string :status
      t.datetime :start_at
      t.datetime :end_at
      t.integer :total_price

      t.timestamps
    end
  end
end
