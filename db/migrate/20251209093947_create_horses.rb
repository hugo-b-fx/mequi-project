class CreateHorses < ActiveRecord::Migration[7.1]
  def change
    create_table :horses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :age
      t.string :breed
      t.string :discipline

      t.timestamps
    end
  end
end
