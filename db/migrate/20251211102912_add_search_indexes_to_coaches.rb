class AddSearchIndexesToCoaches < ActiveRecord::Migration[7.1]
  def change
    add_index :coaches, :location
    add_index :coaches, :price_per_session
    add_index :coaches, :specialities
    add_index :users, :first_name
    add_index :users, :last_name
  end
end
