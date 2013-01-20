class AddLeadEvalToCustomerxSalesLeads < ActiveRecord::Migration
  def change
    add_column :customerx_sales_leads, :lead_eval, :text
  end
end
