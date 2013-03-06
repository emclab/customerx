class AddLogToCustomerxLogs < ActiveRecord::Migration
  def change
    add_column :customerx_logs, :log, :text
  end
end
