# encoding: utf-8
require 'spec_helper'

describe "TestPaths" do
  describe "GET /customerx_test_paths" do
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      lsource = FactoryGirl.create(:lead_source)
      qs = FactoryGirl.create(:quality_system)
      add = FactoryGirl.create(:address)
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customer_status_categories', :action => 'create')
      ua1 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customer_status_categories', :action => 'update')
      ua2 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customers', :action => 'index')
      ua3 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customers', :action => 'create')
      ua4 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customers', :action => 'update')
      ua41 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customers', :action => 'show')
      ua5 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'index')
      ua6 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'create')
      ua7 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'update')
      ua8 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'show')
      ua9 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_categories', :action => 'update')
      ua10 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_categories', :action => 'create')
      ua11 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customer_comm_records', :action => 'index' )
      ua12 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customer_comm_records', :action => 'show' )
      ua13 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customer_comm_records', :action => 'create' )
      ua14 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customer_comm_records', :action => 'update' )
      ua15 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'create_customer_comm_record' )
      ua16 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'create_sales_lead' )
      ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
      ur1 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua1.id)
      ur2 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua2.id)
      ur2 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua3.id)
      ur4 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua4.id)
      ur41 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua41.id)
      ur5 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua5.id)
      ur6 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua6.id)
      ur7 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua7.id)
      ur8 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua8.id)
      ur9 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua9.id)
      ur10 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua10.id)
      ur11 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua11.id)
      ur12 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua12.id)
      ur13 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua13.id)
      ur14 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua14.id)
      ur15 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua15.id)
      ur15 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua16.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      #session[:user_id] = u.id
      #session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
      @cate1 = FactoryGirl.create(:customer_status_category)
      @cate2 = FactoryGirl.create(:customer_status_category, :cate_name => 'newnew cate')
      @cust = FactoryGirl.create(:customer, :zone_id => z.id, :sales_id => @u.id, :last_updated_by_id => @u.id, :quality_system_id => qs.id, :address => add)
      @slead = FactoryGirl.create(:sales_lead, :provider_id => @u.id, :last_updated_by_id => @u.id, :customer_id => @cust.id, :lead_source_id => lsource.id)
      @ccate = FactoryGirl.create(:comm_category, :last_updated_by_id => @u.id)
      @crecord = FactoryGirl.create(:customer_comm_record, :customer_id => @cust.id, :comm_category_id => @ccate.id)
      visit '/'
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'login'
    end
    
    #customer status category
    it "should display customer status category index page" do     
      visit customer_status_categories_path
      page.body.should have_content("Customerx")
    end

    it "should display edit page for the customer status category record" do
      visit edit_customer_status_category_path(@cate2)
      #response.should have_selector("input", :type => "text", :name => "customer_status_category[cate_name]", :value => @cate2.cate_name)
      page.body.should include(@cate2.cate_name)
    end
    
    it "should display new page for customer status category" do
      visit new_customer_status_category_path
      page.body.should have_content("New Customer Status Category")
    end
    
    #quality system    
    it "should display quality system index page" do
      visit quality_systems_path
      page.body.should have_content("Customerx")
    end
    
    #customers
    it "should display customer index page" do
      visit customers_path
      page.body.should have_content('Customers')
    end
    
    it "should work with links on index page" do
      visit customers_path
      click_link '输入客户'
      visit customers_path
      click_link @cust.id.to_s
      visit customers_path
      click_link 'Edit'
      visit customers_path
      click_link 'SalesLeads'
      visit customers_path
      click_link "CommRecords"
      visit customers_path
      click_link "Back"
    end
    
    it "should display new customer page" do
      visit new_customer_path
      page.body.should have_content('New Customer')
    end
    
    it "should display edit customer page" do
      visit edit_customer_path(@cust)
      page.body.should have_content('Edit Customer Info')
      
    end
    
    #sales lead
    it "should display index customer's sales leads page" do
      visit customer_sales_leads_path(@cust)
      page.body.should have_content('Sales Leads')
    end
    
    it "should work with all links in sales leads index page" do
      visit customer_sales_leads_path(@cust)
      click_link 'Edit'
      visit customer_sales_leads_path(@cust)
      click_link @slead.id.to_s
      visit customer_sales_leads_path(@cust)
      click_link 'Back'
      visit customer_sales_leads_path(@cust)
      click_link '输入Leads'
    end
    
    it "should display index for sales lead without customer" do
      visit sales_leads_path
      page.body.should have_content('Sales Leads')
    end
    
    it "should display new sales leads page" do
      visit new_customer_sales_lead_path(@cust)
      page.body.should have_content('New Sales Lead')
    end
    
    it "should display edit sales leads page" do
      visit edit_customer_sales_lead_path(@cust, @slead)
      page.body.should have_content('Edit Sales Lead')    
    end
    
    it "should show sales leads" do
      visit customer_sales_lead_path(@cust, @slead)
      page.body.should have_content('Sales Lead Info')
    end
    
    it "should work with link on show sales lead page" do
      visit customer_sales_lead_path(@cust, @slead)
      click_link '新Log'
    end
    
    #comm category
    it "should display index page for comm category" do
      visit comm_categories_path
      page.body.should have_content('Comm Categories')
    end
    
    it "should work with links on comm category index page" do
      visit comm_categories_path
      click_link 'Edit'
      #visit comm_categories_path
      #click_link 'Back'
      visit comm_categories_path
      click_link "New Comm Category"
    end
    
    it "should display edit page for comm category" do
      visit edit_comm_category_path(@ccate)
      page.body.should have_content('Edit Comm Category')
    end
    
    it "should display new comm_category" do
      visit new_comm_category_path
      page.body.should have_content('New Comm Category')
    end
    
    #customer_comm_record
    it "should display customer_comm_record index page" do
      visit customer_comm_records_path
      page.body.should have_content('Customer Comm Records')
    end
    
    it "should work with links on customer comm record index page" do
      visit customer_comm_records_path
      click_link @crecord.id.to_s
      visit customer_comm_records_path
      click_link 'New Customer Comm Record'
      visit customer_comm_records_path
      click_link 'Back'
      visit customer_comm_records_path
      click_link 'Edit'
    end
    
    it "should display comm record edit page" do
      visit edit_customer_customer_comm_record_path(@cust, @crecord)
      page.body.should have_content('修改客户联系记录')
    end
    
    it "should show customer_comm_record page" do
      visit customer_customer_comm_record_path(@cust, @crecord)
      page.body.should have_content('客户交流记录内容')
    end
    
    it "should work with link on show customer_comm_record page" do
      visit customer_customer_comm_record_path(@cust, @crecord)
      click_link '新Log'
    end
  end
end
