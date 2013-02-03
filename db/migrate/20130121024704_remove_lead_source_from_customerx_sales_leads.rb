class RemoveLeadSourceFromCustomerxSalesLeads < ActiveRecord::Migration
  def up
    remove_column :customerx_sales_leads, :lead_source
  end

  def down
    add_column :customerx_sales_leads, :lead_source, :string
  end
end
