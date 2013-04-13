class RemoveWhichTableFromCustomerxLogs < ActiveRecord::Migration
  def up
    remove_column :customerx_logs, :which_table
  end

  def down
    add_column :customerx_logs, :which_table, :string
  end
end
