class CreateListings < ActiveRecord::Migration[7.0]
  def change
    create_table :listings do |t|
      t.string :image
      t.text :caption
      t.integer :category_id
      t.integer :buyer_id
      t.boolean :purchased

      t.timestamps
    end
  end
end
