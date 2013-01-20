class RemoveLeadEvelFromCustomerxSalesLeads < ActiveRecord::Migration
  def up
    remove_column :customerx_sales_leads, :lead_evel
  end

  def down
    add_column :customerx_sales_leads, :lead_evel, :text
  end
end
