class RemoveImageFromListings < ActiveRecord::Migration[7.0]
  def change
    remove_column :listings, :image, :string
  end
end
