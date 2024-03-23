class AddSellerToOffers < ActiveRecord::Migration[7.0]
  def change
    add_reference :offers, :seller, null: false, foreign_key: {to_table: :users}
  end
end
