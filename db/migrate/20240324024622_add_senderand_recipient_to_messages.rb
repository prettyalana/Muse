class AddSenderandRecipientToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :sender, null: false, foreign_key: {to_table: :users}
    add_reference :messages, :recipient, null: false, foreign_key: {to_table: :users}
  end
end
