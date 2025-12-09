class CreateCoachAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :coach_availabilities do |t|
      t.references :coach, null: false, foreign_key: true
      t.time :start_time
      t.time :end_time
      t.string :days_off

      t.timestamps
    end
  end
end
