require 'spec_helper'

module Customerx
  describe SalesLeadsController do

    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
    end
  
    render_views
      
    describe "GET 'index'" do
      it "returns http success" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'index')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        get 'index' , {:use_route => :customerx}
        assigns(:sales_leads).should eq([lead])        
      end
      
      it "should display only the sales leads for @customer if @customer present" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'index')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        cust1 = FactoryGirl.create(:customer, :active => false, :name => 'new new name', :short_name => 'shoort name', 
                                   :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        lead1 = FactoryGirl.create(:sales_lead, :customer_id => cust1.id, :lead_info => 'a new lead')
        get 'index' , {:use_route => :customerx, :customer_id => cust1.id}
        assigns(:sales_leads).should eq([lead1])                
      end
      
      it"should reject for users without right" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'unknow-right')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        get 'index' , {:use_route => :customerx}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")                   
      end
    end
  
    describe "GET 'new'" do
      it "returns http success for user with proper right" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.build(:sales_lead, :customer_id => cust.id)        
        get 'new', {:use_route => :customerx, :customer_id => cust.id}
        response.should be_success
      end
      
      it "should redirect user without proper right" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'unknown')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.build(:sales_lead, :customer_id => cust.id)        
        get 'new', {:use_route => :customerx, :customer_id => cust.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")        
      end
      
    #  it "should display customer not selected if without customer but with proper right" do
  #      cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
   #     z = FactoryGirl.create(:zone, :zone_name => 'hq')
  #      type = FactoryGirl.create(:group_type, :name => 'employee')
    #    ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
    #    ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'create')
   #     ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
   #    ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
    #    u = FactoryGirl.create(:user, :user_levels => [ul])
    #    session[:user_id] = u.id
    #    session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
   #     cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
   #     lead = FactoryGirl.build(:sales_lead, :customer_id => cust.id)        
   #     get 'new', {:use_route => :customerx}
   #     response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO customer selected!")       
   #   end      
    end
  
    describe "GET 'create'" do
      it "should be OK for users with right" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.attributes_for(:sales_lead, :customer_id => cust.id)   
        get 'create', {:use_route => :customerx, :customer_id => cust.id, :sales_lead => lead}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Sales Lead Saved!")
      end
      
      it "should render template new if data error" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.attributes_for(:sales_lead, :customer_id => cust.id, :subject => nil, )        
        get 'create', {:use_route => :customerx, :customer_id => cust.id}
        response.should render_template("new")
      end
      
    end
  
    describe "GET 'edit'" do
      it "returns http success for users with right" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'update')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)  
        get 'edit', {:use_route => :customerx, :customer_id => cust.id, :id => lead.id}
        response.should be_success
      end
      
      it "should reject users without right" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'updatexxx')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)  
        get 'edit', {:use_route => :customerx, :customer_id => cust.id, :id => lead.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")        
      end
      
      it "should display error if no customer provided for edit" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'update')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)  
        get 'edit', {:use_route => :customerx, :id => lead.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Missing Customer!")
      end
    end
  
    describe "GET 'update'" do
      it "should be OK uses with rights" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'update')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)  
        get 'update', {:use_route => :customerx, :customer_id => cust.id, :id => lead.id, :sales_lead => {:lead_info => 'there is some changes', :subject => 'a new subject'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Sales Lead Updated!")
      end
      
      it "should redirec to edit page with data error" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'update')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)  
        get 'update', {:use_route => :customerx, :customer_id => cust.id, :id => lead.id, :sales_lead => {:lead_info => nil, :subject => 'a new subject'}}
        response.should render_template('edit')
      end
 
    end
  
    describe "GET 'show'" do
      it "returns success for users with right" do
        cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        ls = FactoryGirl.create(:misc_definition, :for_which => 'sales_lead_source')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_sales_leads', :action => 'show')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id, :lead_source_id => ls.id)  
        get 'show', {:use_route => :customerx, :customer_id => cust.id, :id => lead.id}
        response.should be_success
      end
    end
  
  end
end
