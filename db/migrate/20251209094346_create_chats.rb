class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :user, null: false, foreign_key: true
      t.references :coach, null: false, foreign_key: { to_table: :users}
      t.boolean :is_ai_chat

      t.timestamps
    end
  end
end
