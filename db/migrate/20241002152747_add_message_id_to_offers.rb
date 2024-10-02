class AddMessageIdToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :message_id, :integer
  end
end
