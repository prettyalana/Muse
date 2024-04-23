class RemoveMessagesIdFromOffers < ActiveRecord::Migration[7.0]
  def up
    remove_column :offers, :message_id
  end

  def down
    add_column :offers, :message_id, :integer
  end
end
