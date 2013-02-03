require 'spec_helper'

module Customerx
  describe LeadLogsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
    end
  
    render_views
    
    describe "GET 'index'" do
      it "returns http success for users with right" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_lead_logs', :action => 'index')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.create(:lead_log, :sales_lead_id => lead.id)
        get 'index', {:use_route => :customerx, :sales_lead_id => lead.id}
        response.should be_success
        assigns(:lead_logs).should eq([log])
      end
      
      it "should display only logs for the sales lead" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_lead_logs', :action => 'index')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.create(:lead_log, :sales_lead_id => lead.id)
        log1 = FactoryGirl.create(:lead_log, :log => 'new subject', :sales_lead_id => lead.id + 1)
        get 'index', {:use_route => :customerx, :sales_lead_id => lead.id}
        response.should be_success
        assigns(:lead_logs).should eq([log])
      end
      
      it "should reject users without right" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_lead_logs', :action => 'unknown_action')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.create(:lead_log, :sales_lead_id => lead.id)
        get 'index', {:use_route => :customerx, :sales_lead_id => lead.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!") 
      end
    end
  
    describe "GET 'new'" do
      it "returns http success for users with right" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_lead_logs', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:lead_log, :sales_lead_id => lead.id)
        get 'new', {:use_route => :customerx, :sales_lead_id => lead.id, :lead_log => log}
        response.should be_success
      end
      
      it "should reject for users without right" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_lead_logs', :action => 'unknow')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:lead_log, :sales_lead_id => lead.id)
        get 'new', {:use_route => :customerx, :sales_lead_id => lead.id, :lead_log => log}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
      
      it "should reject for user without associated sales_lead" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_lead_logs', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:lead_log, :sales_lead_id => lead.id)
        get 'new', {:use_route => :customerx, :lead_log => log}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Sales Lead selected!")
      end
    end
  
    describe "GET 'create'" do
      it "returns http success for users with right" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_lead_logs', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:lead_log, :sales_lead_id => lead.id)
        get 'create', {:use_route => :customerx, :sales_lead_id => lead.id, :lead_log => log}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Lead Log Saved!")
      end
      
      it "should render new for data error" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_lead_logs', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:lead_log, :sales_lead_id => lead.id, :log => nil)
        get 'create', {:use_route => :customerx, :sales_lead_id => lead.id, :lead_log => log}
        response.should render_template("new")
      end
    end
  
  end
end
