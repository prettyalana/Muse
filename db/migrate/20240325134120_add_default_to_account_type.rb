class AddDefaultToAccountType < ActiveRecord::Migration[7.0]
  def change
    change_column_default(
      :users,
      :account_type,
      from: nil,
      to: "buyer"
    )
  end
end
