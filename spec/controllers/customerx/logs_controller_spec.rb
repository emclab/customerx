require 'spec_helper'

module Customerx
  describe LogsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
    end
  
    render_views
    
    describe "GET 'index'" do
      it "returns sales lead logs for users with index right with @sales_lead passes in" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_sales_lead')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id + 1, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.create(:log, :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        get 'index', {:use_route => :customerx, :sales_lead_id => lead.id, :which_table => 'sales_lead'}
        #response.should be_success
        assigns(:logs).should eq([log])
      end
      
      it "should return logs for sales_lead for user with index right without @sales_lead passes in" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_sales_lead')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id + 1, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.create(:log, :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        log1 = FactoryGirl.create(:log, :log => 'newnew', :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        get 'index', {:use_route => :customerx, :sales_lead_id => nil, :which_table => 'sales_lead'}
        #response.should be_success
        assigns(:logs).should eq([log1,log])
      end
      
      it "should return logs for sales lead for current user with index_individual right with @sales_lead passes in" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_individual_sales_lead')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id , :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.create(:log, :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        get 'index', {:use_route => :customerx, :sales_lead_id => lead.id, :which_table => 'sales_lead'}
        #response.should be_success
        assigns(:logs).should eq([log])
      end
      
      it "should return lead logs for current user with index_individual_sales_lead right without @sales_lead" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_individual_sales_lead')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.create(:log, :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        log1 = FactoryGirl.create(:log, :log => 'newnew', :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        get 'index', {:use_route => :customerx, :sales_lead_id => nil, :which_table => 'sales_lead'}
        #response.should be_success
        assigns(:logs).should eq([log1,log])
      end
      
      it "should return lead logs for zone right with @sales_lead passes in" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_zone_sales_lead')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.create(:log, :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        log1 = FactoryGirl.create(:log, :log => 'newnew', :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        get 'index', {:use_route => :customerx, :sales_lead_id => lead.id, :which_table => 'sales_lead'}
        #response.should be_success
        assigns(:logs).should eq([log1,log])
      end
      
      it "should return lead logs for current user with index_zone_sales_lead right without @sales_lead" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_zone_sales_lead')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.create(:log, :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        log1 = FactoryGirl.create(:log, :log => 'newnew', :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        get 'index', {:use_route => :customerx, :sales_lead_id => nil, :which_table => 'sales_lead'}
        #response.should be_success
        assigns(:logs).should eq([log1,log])
      end
      
      it "returns customer comm record logs for users with index right with @customer_comm_record passes in" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        c_cate = FactoryGirl.create(:comm_category)
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id + 1,:customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        log = FactoryGirl.create(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        get 'index', {:use_route => :customerx, :customer_comm_record_id => rec.id, :which_table => 'customer_comm_record'}
        #response.should be_success
        assigns(:logs).should eq([log])
      end
      
      it "should return logs for customer comm record for users with index right without @customer_comm_record passes in" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        c_cate = FactoryGirl.create(:comm_category)
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id + 1, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        log = FactoryGirl.create(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        log1 = FactoryGirl.create(:log, :log => 'newnew', :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        get 'index', {:use_route => :customerx, :customer_comm_record_id => nil, :which_table => 'customer_comm_record'}
        #response.should be_success
        assigns(:logs).should eq([log1,log])
      end
      
      it "should return comm logs for current user with index individual_customer_comm_record with @customer_comm_record passes in" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        c_cate = FactoryGirl.create(:comm_category)
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_individual_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id ,:customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        log = FactoryGirl.create(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        get 'index', {:use_route => :customerx, :customer_comm_record_id => rec.id, :which_table => 'customer_comm_record'}
        #response.should be_success
        assigns(:logs).should eq([log])
      end
      
      it "should return comm logs for current user with index_individual_customer_comm_record without @customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        c_cate = FactoryGirl.create(:comm_category)
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_individual_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        log = FactoryGirl.create(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        log1 = FactoryGirl.create(:log, :log => 'newnew', :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        get 'index', {:use_route => :customerx, :customer_comm_record_id => nil, :which_table => 'customer_comm_record'}
        #response.should be_success
        assigns(:logs).should eq([log1,log])
      end
      
      it "should return comm logs for zone right with @customer_comm_record passes in" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        c_cate = FactoryGirl.create(:comm_category)
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_zone_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        log = FactoryGirl.create(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        log1 = FactoryGirl.create(:log, :log => 'newnew', :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        get 'index', {:use_route => :customerx, :customer_comm_record_id => rec.id, :which_table => 'customer_comm_record'}
        #response.should be_success
        assigns(:logs).should eq([log1,log])
      end
      
      it "should return comm logs for current user with index_zone_customer_comm_record right without @customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        c_cate = FactoryGirl.create(:comm_category)
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'index_zone_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        log = FactoryGirl.create(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        log1 = FactoryGirl.create(:log, :log => 'newnew', :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        get 'index', {:use_route => :customerx, :customer_comm_record_id => nil, :which_table => 'customer_comm_record'}
        #response.should be_success
        assigns(:logs).should eq([log1,log])
      end
      
      it "should reject no right" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        c_cate = FactoryGirl.create(:comm_category)
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'no_index_zone_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :sales_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        log = FactoryGirl.create(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        log1 = FactoryGirl.create(:log, :log => 'newnew', :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        get 'index', {:use_route => :customerx, :customer_comm_record_id => rec.id, :which_table => 'customer_comm_record'}
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    describe "GET 'new'" do
      it "should create log for users with @sale_lead" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'create_sales_lead')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:log, :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        get 'new', {:use_route => :customerx, :sales_lead_id => lead.id, :log => log, :which_table => 'sales_lead'}
        response.should be_success
      end
      
      it "should create log for users with @customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'create_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        get 'new', {:use_route => :customerx, :customer_comm_record_id => rec.id, :log => log, :which_table => 'customer_comm_record'}
        response.should be_success
      end
      
      it "should redirect if no @customer_comm_record passes in" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'create_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        get 'new', {:use_route => :customerx, :customer_comm_record_id => nil, :log => log, :which_table => 'customer_comm_record'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO customer comm record selected for log!")
      end
      
      it "should redirect user without right" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'unknow')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:log, :sales_lead_id => lead.id, :which_table => "sales_lead")
        get 'new', {:use_route => :customerx, :sales_lead_id => lead.id, :customer_comm_record_id => nil, :log => log, :which_table => "sales_lead"}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    describe "GET 'create'" do
      it "should create for user with @sales_lead" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'create_sales_lead')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:log, :sales_lead_id => lead.id, :customer_comm_record_id => nil, :which_table => 'sales_lead')
        get 'create', {:use_route => :customerx, :sales_lead_id => lead.id, :log => log, :which_table => 'sales_lead'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Log Saved!")
      end
      
      it "should create for user with @customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'create_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record')
        get 'create', {:use_route => :customerx, :customer_comm_record_id => rec.id, :log => log, :which_table => 'customer_comm_record'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Log Saved!")        
      end
      
      it "should redirect without both @sales_lead and @customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'create_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record', :last_updated_by_id => u.id)
        get 'create', {:use_route => :customerx, :customer_comm_record_id => nil, :sales_lead_id => nil, :log => log, :which_table => 'customer_comm_record'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO parental object selected!")
      end
      
      it "should redirect for user without right" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'unknow')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:log, :sales_lead_id => lead.id, :which_table => "sales_lead")
        get 'create', {:use_route => :customerx, :sales_lead_id => lead.id, :customer_comm_record_id => nil, :log => log, :which_table => "sales_lead"}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
      
      it "should render new with data error" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_logs', :action => 'create_customer_comm_record')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        log = FactoryGirl.attributes_for(:log, :customer_comm_record_id => rec.id, :sales_lead_id => nil, :which_table => 'customer_comm_record', :log => nil)
        get 'create', {:use_route => :customerx, :customer_comm_record_id => rec.id, :log => log, :which_table => 'customer_comm_record'}
        response.should render_template('new')
      end
    end
  
  end
end
