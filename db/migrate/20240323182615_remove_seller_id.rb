class RemoveSellerId < ActiveRecord::Migration[7.0]
  def change
    remove_column :offers, :seller_id
  end
end
