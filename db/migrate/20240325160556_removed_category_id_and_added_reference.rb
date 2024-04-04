class RemovedCategoryIdAndAddedReference < ActiveRecord::Migration[7.0]
  def change
    remove_column :listings, :category_id, :boolean
    add_reference :listings, :category, null: false, foreign_key: {to_table: :categories}
  end
end
