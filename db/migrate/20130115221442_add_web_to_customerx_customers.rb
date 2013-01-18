class AddWebToCustomerxCustomers < ActiveRecord::Migration
  def change
    add_column :customerx_customers, :web, :string
  end
end
