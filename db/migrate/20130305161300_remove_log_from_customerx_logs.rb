class RemoveLogFromCustomerxLogs < ActiveRecord::Migration
  def up
    remove_column :customerx_logs, :log
  end

  def down
    add_column :customerx_logs, :log, :string
  end
end
