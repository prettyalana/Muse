class AddPersonalInformationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :address, :string
    add_column :users, :image, :string
    add_column :users, :bio, :text
    add_column :users, :location, :string
    add_column :users, :account_type, :string
  end
end
