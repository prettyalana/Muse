class DropChatTables < ActiveRecord::Migration[8.0]
  def change
    drop_table :chat_bot_messages
    drop_table :chat_bots
    drop_table :chats
  end
end
