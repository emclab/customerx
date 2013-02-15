class AddInitialOrderTotalToCustomerxSalesLeads < ActiveRecord::Migration
  def change
    add_column :customerx_sales_leads, :initial_order_total, :integer
  end
end
