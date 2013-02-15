class RemoveShippingAddressFromCustomerxCustomers < ActiveRecord::Migration
  def up
    remove_column :customerx_customers, :shipping_address
  end

  def down
    add_column :customerx_customers, :shipping_address, :text
  end
end
