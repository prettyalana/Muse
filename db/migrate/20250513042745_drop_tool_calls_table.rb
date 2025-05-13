class DropToolCallsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :tool_calls
  end
end
