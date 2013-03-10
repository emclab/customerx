require 'spec_helper'

module Customerx
  describe MiscDefinitionsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
    end
  
    render_views
    
    describe "GET 'index'" do
      it "returns customer comm categories" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'no_name_tables', :action => 'action')   #open to all users.
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        qs = FactoryGirl.create(:misc_definition, :active => true, :last_updated_by_id => u.id, :for_which => 'customer_comm_category')
        get 'index' , {:use_route => :customerx, :for_which => 'customer_comm_category'}
        #response.should be_success
        assigns(:misc_definitions).should eq([qs])
      end
      
      it "should list all customer comm category for users with update/create right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_comm_category')   #open to all users.
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        qs = FactoryGirl.create(:misc_definition, :active => true, :last_updated_by_id => u.id, :for_which => 'customer_comm_category')
        qs1 = FactoryGirl.create(:misc_definition, :name => 'a new', :active => true, :last_updated_by_id => u.id, :for_which => 'customer_comm_category')
        get 'index' , {:use_route => :customerx, :for_which => 'customer_comm_category'}
        #response.should be_success
        assigns(:misc_definitions).should eq([qs,qs1])
      end
      
      it "returns customer status categories" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'no_name_tables', :action => 'action')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        cate = FactoryGirl.create(:misc_definition, :active => true, :last_updated_by_id => u.id, :for_which => 'customer_status')
        get 'index' , {:use_route => :customerx, :for_which => 'customer_status'}
        response.should be_success
        assigns(:misc_definitions).should eq([cate])
      end
      
      it "should display all customer status categories for users who has create/update right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_customer_status')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cate1 = FactoryGirl.create(:misc_definition, :last_updated_by_id => u.id, :for_which => 'customer_status')
        cate2 = FactoryGirl.create(:misc_definition, :last_updated_by_id => u.id, :name => 'newnew cate', :active => false, :for_which => 'customer_status')
        get 'index', {:use_route => :customerx, :for_which => 'customer_status'}
        response.should be_success
        assigns(:misc_definitions).should eq([cate1, cate2])
      end
      
      it "returns active lead sources" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'no_name_tables', :action => 'action')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        ls = FactoryGirl.create(:misc_definition, :active => true, :last_updated_by_id => u.id, :for_which => 'sales_lead_source')
        get 'index' , {:use_route => :customerx, :for_which => 'sales_lead_source'}
        response.should be_success
        assigns(:misc_definitions).should eq([ls])
      end
      
      it "should displace all lead sources for users who has create/update right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_sales_lead_source')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        ls1 = FactoryGirl.create(:misc_definition, :last_updated_by_id => u.id, :for_which => 'sales_lead_source')
        ls2 = FactoryGirl.create(:misc_definition, :name => 'newnew ls', :active => false, :last_updated_by_id => u.id, :for_which => 'sales_lead_source')
        get 'index', {:use_route => :customerx, :for_which => 'sales_lead_source'}
        response.should be_success
        assigns(:misc_definitions).should eq([ls1, ls2])
      end
      
      it "should redirect if no for_which passed in" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'no_name_tables', :action => 'action')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        ls = FactoryGirl.create(:misc_definition, :active => true, :last_updated_by_id => u.id, :for_which => 'sales_lead_source')
        get 'index' , {:use_route => :customerx, :for_which => 'nil'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Initial Params Error!") 
      end
    end
  
    describe "GET 'new'" do
      it "returns http success for sales lead with create action rights" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_sales_lead_source')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        get 'new', {:use_route => :customerx, :for_which => 'sales_lead_source'}
        response.should be_success
      end
      
      it "returns http success for customer comm category with create action rights" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_customer_comm_category')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        get 'new', {:use_route => :customerx, :for_which => 'customer_comm_category'}
        response.should be_success
      end
      
      it "returns http success for customer status category with create action rights" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_customer_status')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        get 'new', {:use_route => :customerx, :for_which => 'customer_status'}
        response.should be_success
      end
      
      it "returns http success for quality system with create action rights" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_customer_quality_system')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        get 'new', {:use_route => :customerx, :for_which => 'customer_qs'}
        response.should be_success
      end
      
      it "should redirect for no right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'no-create_customer_quality_system')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        get 'new', {:use_route => :customerx, :for_which => 'customer_qs'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    describe "GET 'create'" do
      it "should save for sales lead source with create right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_sales_lead_source')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.attributes_for(:misc_definition, :for_which => 'sales_lead_source')
        get 'create', {:use_route => :customerx, :misc_definition => qs, :for_which => 'sales_lead_source'}
        response.should redirect_to misc_definitions_path(:for_which => 'sales_lead_source')
      end
      
      it "should save for comm record with create right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_customer_comm_category')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.attributes_for(:misc_definition, :for_which => 'customer_comm_category')
        get 'create', {:use_route => :customerx, :misc_definition => qs, :for_which => 'customer_comm_category'}
        response.should redirect_to misc_definitions_path(:for_which => 'customer_comm_category')
      end
      
      it "should save for customer status with create right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_customer_status')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.attributes_for(:misc_definition, :for_which => 'customer_status')
        get 'create', {:use_route => :customerx, :misc_definition => qs, :for_which => 'customer_status'}
        response.should redirect_to misc_definitions_path(:for_which => 'customer_status')
      end
      
      it "should save for quality system with create right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_customer_quality_system')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.attributes_for(:misc_definition, :for_which => 'customer_qs')
        get 'create', {:use_route => :customerx, :misc_definition => qs, :for_which => 'customer_qs'}
        response.should redirect_to misc_definitions_path(:for_which => 'customer_qs')
      end
      
      it "should render new with data error" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'create_customer_quality_system')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.attributes_for(:misc_definition, :name => nil, :for_which => 'cusomer_qs')
        get 'create', {:use_route => :customerx, :misc_definition => qs, :for_which => 'customer_qs'}
        response.should render_template('new')
      end
      
      it "should redirect with no right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'no-create_quality_system')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.attributes_for(:misc_definition)
        get 'create', {:use_route => :customerx, :misc_definition => qs, :for_which => 'customer_qs'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!") 
      end
    end
  
    describe "GET 'edit'" do
      it "should edit sales_lead_source with proper right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'update_sales_lead_source')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'sales_lead_source')
        get 'edit', {:use_route => :customerx, :id => qs.id, :for_which => 'sales_lead_source'}
        response.should be_success
      end
      
      it "should edit comm record with proper right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'update_customer_comm_category')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'customer_comm_category')
        get 'edit', {:use_route => :customerx, :id => qs.id, :for_which => 'customer_comm_category'}
        response.should be_success
      end
      
      it "should edit customer status with proper right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'update_customer_status')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'customer_status')
        get 'edit', {:use_route => :customerx, :id => qs.id, :for_which => 'customer_status'}
        response.should be_success
      end
      
      it "should edit quality system with proper right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'update_customer_quality_system')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'customer_qs')
        get 'edit', {:use_route => :customerx, :id => qs.id, :for_which => 'customer_qs'}
        response.should be_success
      end
      
      it "should redirect with no right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'no-update_customer_quality_system')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'customer_qs')
        get 'edit', {:use_route => :customerx, :id => qs.id, :for_which => 'customer_qs'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    describe "GET 'update'" do
      it "should update sales_lead_source with update right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'update_sales_lead_source')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'sales_lead_source')
        get 'update', {:use_route => :customerx, :id => qs.id, :misc_definition => {:name => 'newnew name'}, :for_which => 'sales_lead_source'}
        response.should redirect_to misc_definitions_path(:for_which => 'sales_lead_source')
      end
      
      it "should update customer comm record with update right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'update_customer_comm_category')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'customer_comm_category')
        get 'update', {:use_route => :customerx, :id => qs.id, :misc_definition => {:name => 'newnew name'}, :for_which => 'customer_comm_category'}
        response.should redirect_to misc_definitions_path(:for_which => 'customer_comm_category')
      end
      
      it "should update customer status with update right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'update_customer_status')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'customer_status')
        get 'update', {:use_route => :customerx, :id => qs.id, :misc_definition => {:name => 'newnew name'}, :for_which => 'customer_status'}
        response.should redirect_to misc_definitions_path(:for_which => 'customer_status')
      end
      
      it "should update quality system with update right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'update_customer_quality_system')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'customer_qs')
        get 'update', {:use_route => :customerx, :id => qs.id, :misc_definition => {:name => 'newnew name'}, :for_which => 'customer_qs'}
        response.should redirect_to misc_definitions_path(:for_which => 'customer_qs')
      end
      
      it "shoudl render edit with data error" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'update_customer_quality_system')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'customer_qs')
        get 'update', {:use_route => :customerx, :id => qs.id, :misc_definition => {:name => ''}, :for_which => 'customer_qs'}
        response.should render_template('edit')
      end
      
      it "should redirect with no right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_misc_definitions', :action => 'no-update_customer_quality_system')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        qs = FactoryGirl.create(:misc_definition, :for_which => 'customer_qs')
        get 'update', {:use_route => :customerx, :id => qs.id, :misc_definition => {:name => ''}, :for_which => 'customer_qs'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!") 
      end
    end
  
  end
end
