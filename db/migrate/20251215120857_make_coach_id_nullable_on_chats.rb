class MakeCoachIdNullableOnChats < ActiveRecord::Migration[7.1]
  def change
    change_column_null :chats, :coach_id, true
  end
end
