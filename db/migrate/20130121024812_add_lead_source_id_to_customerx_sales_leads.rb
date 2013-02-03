class AddLeadSourceIdToCustomerxSalesLeads < ActiveRecord::Migration
  def change
    add_column :customerx_sales_leads, :lead_source_id, :integer
  end
end
