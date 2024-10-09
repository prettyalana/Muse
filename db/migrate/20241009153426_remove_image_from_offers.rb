class RemoveImageFromOffers < ActiveRecord::Migration[7.0]
  def change
    remove_column :offers, :image, :string
  end
end
