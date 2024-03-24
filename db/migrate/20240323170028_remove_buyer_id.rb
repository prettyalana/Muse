class RemoveBuyerId < ActiveRecord::Migration[7.0]
  def change
    remove_column :listings, :buyer_id
  end
end
