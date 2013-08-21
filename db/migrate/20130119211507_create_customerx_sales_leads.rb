class CreateCustomerxSalesLeads < ActiveRecord::Migration
  def change
    create_table :customerx_sales_leads do |t|
      t.integer :customer_id
      t.integer :last_updated_by_id
      t.integer :provider_id
      t.text :lead_info
      t.text :contact_instruction
      t.string :lead_status
      t.text :lead_eval
      t.boolean :sale_success
      t.boolean :close_lead  #close is a verb. close lead?
      t.datetime :close_lead_date
      t.integer :close_lead_by_id
      t.integer :lead_source_id  #ad, corp web, personal contact, conference, exhibit, news. online, walk-in, other
      t.integer :lead_quality  #0..10
      t.integer :lead_accuracy  # 0..10
      t.string :subject
      t.date :lead_date
      t.integer :initial_order_total

      t.timestamps
    end
    
    add_index :customerx_sales_leads, :customer_id
    add_index :customerx_sales_leads, :provider_id
  end
end
