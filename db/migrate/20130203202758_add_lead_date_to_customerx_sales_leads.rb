class AddLeadDateToCustomerxSalesLeads < ActiveRecord::Migration
  def change
    add_column :customerx_sales_leads, :lead_date, :date
  end
end
