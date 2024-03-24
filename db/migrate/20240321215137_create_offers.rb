class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.integer :seller_id
      t.string :image
      t.text :description
      t.integer :listing_id
      t.decimal :price
      t.integer :message_id

      t.timestamps
    end
  end
end
