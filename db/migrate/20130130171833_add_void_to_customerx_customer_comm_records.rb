class AddVoidToCustomerxCustomerCommRecords < ActiveRecord::Migration
  def change
    add_column :customerx_customer_comm_records, :void, :boolean, :default => false
  end
end
