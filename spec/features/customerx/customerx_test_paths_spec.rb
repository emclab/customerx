# encoding: utf-8
require 'spec_helper'

describe "TestPaths" do
  describe "GET /customerx_test_paths" do
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      #z = FactoryGirl.create(:zone, :zone_name => 'hq')
      #type = FactoryGirl.create(:group_type, :name => 'employee')
      qs = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_qs')
      add = FactoryGirl.create(:address)
      #ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ua2 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::Customer.where(:active => true)")
      ua3 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => nil)
      ua4 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua5 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua6 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua7 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua8 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua9 = FactoryGirl.create(:user_access, :action => 'update_customer_comm_category', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua10 = FactoryGirl.create(:user_access, :action => 'create_customer_comm_category', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua11 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::CustomerCommRecord.joins(:customer).
        where(:customerx_customers => {:sales_id => session[:user_id]}).
        order('comm_date DESC')")
      ua12 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua13 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua14 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_customer_comm_records', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua15 = FactoryGirl.create(:user_access, :action => 'create_customer_comm_record', :resource => 'customerx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua151 = FactoryGirl.create(:user_access, :action => 'index_customer_comm_category', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::MiscDefinition.
                     where(:active => true).order('ranking_order')") 
      ua16 = FactoryGirl.create(:user_access, :action => 'index_sales_lead_source', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::MiscDefinition.
                     where(:active => true).order('ranking_order')")
      ua = FactoryGirl.create(:user_access, :action => 'index_customer_status', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::MiscDefinition.
                     where(:active => true).order('ranking_order')")
      ua152 = FactoryGirl.create(:user_access, :action => 'index_customer_quality_system', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::MiscDefinition.
                     where(:active => true).order('ranking_order')")
      ua1 = FactoryGirl.create(:user_access, :action => 'update_customer_status', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua17 = FactoryGirl.create(:user_access, :action => 'update_customer_status', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua18 = FactoryGirl.create(:user_access, :action => 'create_customer_status', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua19 = FactoryGirl.create(:user_access, :action => 'update_customer_quality_system', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua20 = FactoryGirl.create(:user_access, :action => 'create_customer_quality_system', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua21 = FactoryGirl.create(:user_access, :action => 'update_sales_lead_source', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua22 = FactoryGirl.create(:user_access, :action => 'create_sales_lead_source', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua23 = FactoryGirl.create(:user_access, :action => 'update_customer_comm_record', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua24 = FactoryGirl.create(:user_access, :action => 'create_customer_comm_record', :resource => 'customerx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "") 
      ua25 = FactoryGirl.create(:user_access, :action => 'create_sales_lead', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua26 = FactoryGirl.create(:user_access, :action => 'index_sales_lead', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Commonx::Log.where('commonx_logs.sales_lead_id > ?', 0)")      
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      lsource = FactoryGirl.create(:commonx_misc_definition, :for_which => 'sales_lead_source')
      @cate2 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'newnew cate', :last_updated_by_id => @u.id)
      @cust = FactoryGirl.create(:customer, :zone_id => z.id, :sales_id => @u.id, :last_updated_by_id => @u.id, :quality_system_id => qs.id, :address => add)
      @slead = FactoryGirl.create(:sales_lead, :provider_id => @u.id, :last_updated_by_id => @u.id, :customer_id => @cust.id, :lead_source_id => lsource.id)
      @ccate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_category', :active => true, :last_updated_by_id => @u.id)
      @ccate1 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'new', :active => true, :last_updated_by_id => @u.id)
      @ccate2 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_quality_system', :name => 'nnew', :active => true, :last_updated_by_id => @u.id)
      @ccate3 = FactoryGirl.create(:commonx_misc_definition, :for_which => 'sales_lead_source', :name => 'nnnew', :active => true, :last_updated_by_id => @u.id)
      @crecord = FactoryGirl.create(:customer_comm_record, :customer_id => @cust.id, :comm_category_id => @ccate.id)
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customerx', :engine_version => nil, :argument_name => 'customer_comm_record_index_view', 
                              :argument_value => "This is a view") 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customerx', :engine_version => nil, :argument_name => 'sales_lead_index_view', 
                              :argument_value => "This is a view") 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customerx', :engine_version => nil, :argument_name => 'customer_index_view', 
                              :argument_value => "This is a view") 
                              
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end
    
    #customer status category
    it "should display customer status category index page" do     
      visit commonx.misc_definitions_path(:for_which => 'customer_status', :subaction => 'customer_status')
      page.body.should have_content("Customer Status Category")
    end

    it "should display edit page for the customer status category record" do
      visit edit_commonx.misc_definition_path(@cate2, :for_which => 'customer_status', :subaction => 'customer_status')
      page.body.should include(@cate2.name)
    end
    
    it "should display new page for customer status category" do
      visit commonx.new_misc_definition_path(:for_which => 'customer_status', :subaction => 'customer_status')
      page.body.should have_content("New Customer Status Category")
    end
    
    #quality system    
    it "should display quality system index page" do
      visit commonx.misc_definitions_path(:for_which => 'customer_quality_system', :subaction => 'customer_quality_system')
      page.body.should have_content("Quality System")
    end
    
    #customers
    it "should display customer index page" do
      visit customers_path
      page.body.should have_content('Customers')
      page.body.should_not have_content("SalesLeads")
    end
    
    it "should work with links on index page" do
      visit customers_path
      #save_and_open_page
      click_link '输入客户'
      #save_and_open_page
      visit customers_path
      click_link @cust.id.to_s
      visit customers_path
      #save_and_open_page
      click_link 'Edit'
      u = FactoryGirl.create(:engine_config, :argument_name => 'sales_lead', :argument_value => 'true', :engine_name => 'customerx')
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
      u = FactoryGirl.create(:engine_config, :argument_name => 'sales_lead', :argument_value => 'true', :engine_name => 'customerx')
      visit customer_sales_leads_path(@cust)
      page.body.should have_content('Sales Leads')
    end
    
    it "should work with all links in sales leads index page" do
      u = FactoryGirl.create(:engine_config, :argument_name => 'sales_lead', :argument_value => 'true', :engine_name => 'customerx')
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
      u = FactoryGirl.create(:engine_config, :argument_name => 'sales_lead', :argument_value => 'true', :engine_name => 'customerx')
      visit sales_leads_path
      page.body.should have_content('Sales Leads')
    end
    
    it "should display new sales leads page" do
      u = FactoryGirl.create(:engine_config, :argument_name => 'sales_lead', :argument_value => 'true', :engine_name => 'customerx')
      visit new_customer_sales_lead_path(@cust)
      page.body.should have_content('New Sales Lead')
    end
    
    it "should display edit sales leads page" do
      u = FactoryGirl.create(:engine_config, :argument_name => 'sales_lead', :argument_value => 'true', :engine_name => 'customerx')
      visit edit_customer_sales_lead_path(@cust, @slead)
      page.body.should have_content('Edit Sales Lead')    
    end
    
    it "should show sales leads" do
      u = FactoryGirl.create(:engine_config, :argument_name => 'sales_lead', :argument_value => 'true', :engine_name => 'customerx')
      visit customer_sales_lead_path(@cust, @slead)
      page.body.should have_content('Sales Lead Info')
    end
    
    it "should work with link on show sales lead page" do
      u = FactoryGirl.create(:engine_config, :argument_name => 'sales_lead', :argument_value => 'true', :engine_name => 'customerx')
      visit customer_sales_leads_path(@cust)
      #visit customer_sales_lead_path(@cust, @slead)
      click_link @cust.sales_leads.first.id.to_s 
      #save_and_open_page     
      click_link '新Log'
    end
    
    #comm category
    it "should display index page for comm category" do
      visit commonx.misc_definitions_path(:for_which => 'customer_comm_category', :subaction => 'customer_comm_category')
      page.body.should have_content('Comm Categories')
    end
    
    it "should work with links on comm category index page" do
      visit commonx.misc_definitions_path(:for_which => 'customer_comm_category', :subaction => 'customer_comm_category')
      click_link 'Edit'
      page.body.should have_content('Update Customer Comm Category')
      visit commonx.misc_definitions_path(:for_which => 'customer_comm_category', :subaction => 'customer_comm_category')
      click_link "New Comm Category"
      page.body.should have_content('New Customer Comm Category')
    end
    
    it "should work with links on status category index page" do
      visit commonx.misc_definitions_path(:for_which => 'customer_status', :subaction => 'customer_status')
      #save_and_open_page
      page.all('a')[1].click  #list all a -href and click the first one which is a edit.
      #page.find("a:eq(2)").click
      #save_and_open_page
      visit commonx.misc_definitions_path(:for_which => 'customer_status', :subaction => 'customer_status')
      click_link "New Customer Status Category"
    end
    
    it "should work with links on quality system index page" do
      visit commonx.misc_definitions_path(:for_which => 'customer_quality_system', :subaction => 'customer_quality_system')
      #save_and_open_page
      click_link 'Edit'
      visit commonx.misc_definitions_path(:for_which => 'customer_quality_system', :subaction => 'customer_quality_system')
      #save_and_open_page
      click_link "New Quality System"
    end
    
    it "should work with links on sales lead source index page" do
      visit commonx.misc_definitions_path(:for_which => 'sales_lead_source', :subaction => 'sales_lead_source')
      #save_and_open_page
      page.all('a')[1].click  #list all a -href and click the first one which is a edit.
      #save_and_open_page
      visit commonx.misc_definitions_path(:for_which => 'sales_lead_source', :subaction => 'sales_lead_source')
      click_link "New Lead Source"
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
    
    #describe "something needs js", :js => true do
    it "should work with link on show customer_comm_record page" do
      visit customer_customer_comm_records_path(@cust)
      #visit customer_customer_comm_record_path(@cust, @crecord)
      click_link @crecord.id.to_s     
      click_link '新Log'
      #save_and_open_page
      #sleep 1
      #fill_in "log", :with => 'some logs'
      #click_button '保存'
      #page.body.should have_content('Log Saved!')
    end
    #end
    
    it "should work with links on show sales lead page" do
      u = FactoryGirl.create(:engine_config, :argument_name => 'sales_lead', :argument_value => 'true', :engine_name => 'customerx')
      visit customer_sales_leads_path(@cust)
      click_link @slead.id.to_s
      click_link '新Log'
      visit customer_sales_leads_path(@cust)
      click_link 'Edit'
      page.body.should have_content('Edit Sales Lead')
    end
  end
end
