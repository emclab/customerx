require 'spec_helper'

module Customerx
  describe CustomerCommRecordsController do
    before(:each) do
      controller.should_receive(:require_signin)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customerx', :engine_version => nil, :argument_name => 'customer_comm_record_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('cusotmer_comm_record_show_view', 'customerx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customerx', :engine_version => nil, :argument_name => 'customer_comm_record_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('cusotmer_comm_record_index_view', 'customerx')) 
    end
  
    render_views
    
    describe "GET 'index'" do
      it "returns customer comm records for user for his own customers'" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        c_cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_record')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'user', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Customerx::CustomerCommRecord.where(:void => false).where('comm_date > ?', 2.years.ago).
          where(:customer_id => Customerx::Customer.where(:sales_id => session[:user_id]).select('id')).
          order('comm_date DESC')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        get 'index', {:use_route => :customerx}
        assigns(:customer_comm_records).should eq([rec])
      end
      
      it "returns customer comm records for manager users for customers his group" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        c_cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_record')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'user', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Customerx::CustomerCommRecord.where(:void => false).where('comm_date > ?', 2.years.ago).
          where(:customer_id => Customerx::Customer.where(:sales_id => Authentify::UserLevel.where(:sys_user_group_id => session[:user_privilege].user_group_ids).select('user_id')).select('id')).
          order('comm_date DESC')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        ur1 = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul1 = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u1 = FactoryGirl.create(:user, :user_levels => [ul1], :user_roles => [ur1], :email => 'newnew@a.com', :login => 'newnew', :name => 'verynew')
        session[:employee] = true
        session[:user_id] = u1.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u1.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        get 'index', {:use_route => :customerx}
        assigns(:customer_comm_records).should eq([rec])
      end
      
      it "return customer comm records in the same zone for managers" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        c_cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_record')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'user', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Customerx::CustomerCommRecord.where(:void => false).where('comm_date > ?', 2.years.ago).
          where(:customer_id => Customerx::Customer.where(:sales_id => Authentify::UserLevel.joins(:sys_user_group).
          where(:authentify_sys_user_groups => {:zone_id => session[:user_privilege].user_zone_ids}).select('user_id')).select('id')).
          order('comm_date DESC')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        ur1 = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul1 = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u1 = FactoryGirl.create(:user, :user_levels => [ul1], :user_roles => [ur1], :email => 'newnew@a.com', :login => 'newnew', :name => 'verynew')
        session[:employee] = true
        session[:user_id] = u1.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u1.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        get 'index', {:use_route => :customerx}
        assigns(:customer_comm_records).should eq([rec])
      end
      
      it "return customer comm records in the same role for managers" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        c_cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_record')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'user', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Customerx::CustomerCommRecord.where(:void => false).where('comm_date > ?', 2.years.ago).
          where(:customer_id => Customerx::Customer.where(:sales_id => Authentify::UserRole.where(:role_definition_id => session[:user_privilege].user_role_ids).select('user_id')).select('id')).
          order('comm_date DESC')")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        ur1 = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul1 = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u1 = FactoryGirl.create(:user, :user_levels => [ul1], :user_roles => [ur1], :email => 'newnew@a.com', :login => 'newnew', :name => 'verynew')
        session[:employee] = true
        session[:user_id] = u1.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u1.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        get 'index', {:use_route => :customerx}
        assigns(:customer_comm_records).should eq([rec])
      end
      
      it "should return @customer's comm record for user with right" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        c_cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_record')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'user', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "Customerx::CustomerCommRecord.where(:void => true)")  #none returned if this sql_code is executed
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_customers', :role_definition_id => role.id, :rank => 40)
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id, :void => false)
        get 'index', {:use_route => :customerx, :customer_id => cust.id}
        #response.should be_success
        assigns(:customer_comm_records).should eq([rec])
      end
      
      it "should redirect if there is no index right" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        c_cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_record')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'user', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id, :void => false)
        get 'index', {:use_route => :customerx}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=index and resource=customerx/customer_comm_records")
      end
    end
  
    describe "GET 'new'" do
      it "returns http success for users without customer id" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.attributes_for(:customer_comm_record, :customer_id => cust.id)
        get 'new', {:use_route => :customerx}
        response.should be_success
      end
      
      it "should http success for users with customer_id" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.attributes_for(:customer_comm_record, :customer_id => cust.id)
        get 'new', {:use_route => :customerx, :customer_id => cust.id}
        response.should be_success
      end
      
      it "should reject users withour rights" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'unknown-create', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.attributes_for(:customer_comm_record, :customer_id => cust.id)
        get 'new', {:use_route => :customerx, :customer_id => cust.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=new and resource=customerx/customer_comm_records")
      end
    end
  
    describe "GET 'create'" do
      it "should redirect to new page for user without customer_id when customer name not selected" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.attributes_for(:customer_comm_record, :customer_id => nil)
        get 'create', {:use_route => :customerx, :customer_comm_record => rec, :customer_name_autocomplete => nil}
        #response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Communication Record Saved!")
        response.should render_template("new")
      end
      
      it "should create new record for user without customer id but selecting the customer name" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :name => 'tester')
        rec = FactoryGirl.attributes_for(:customer_comm_record, :customer_id => cust.id)
        get 'create', {:use_route => :customerx, :customer_comm_record => rec, :customer_name_autocomplete => cust.name }
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Communication Record Saved!")
      end
      
      it "should create record for user w/ customer_id" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.attributes_for(:customer_comm_record, :customer_id => cust.id)
        get 'create', {:use_route => :customerx, :customer_comm_record => rec, :customer_id => cust.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Communication Record Saved!")
      end
    end
  
    describe "GET 'edit'" do
      it "returns http success for users with right" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_customers', :role_definition_id => role.id, :rank => 1, :sql_code => '')
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        get 'edit', {:use_route => :customerx, :id => rec.id, :customer_id => cust.id}
        response.should be_success
      end
      
      it "should redirect for users without right" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'unknown-update', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "")
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        get 'edit', {:use_route => :customerx, :id => rec.id, :customer_id => cust.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=edit and resource=customerx/customer_comm_records")
      end
    end
  
    describe "GET 'update'" do
      it "should update for users with right" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=content'])
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        get 'update', {:use_route => :customerx, :customer_id => cust.id, :id => rec.id, :customer_comm_record => {:subject => 'new subject'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Comm Record Updated!")
      end
      
      it "should render edit for data error" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_customers', :role_definition_id => role.id, :rank => 1, :sql_code => '')
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=content'])
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        get 'update', {:use_route => :customerx, :customer_id => cust.id, :id => rec.id, :customer_comm_record => {:subject => ''}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "should show customer comm record" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_customers', :role_definition_id => role.id, :rank => 1, :sql_code => '')
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=content'])
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        c_cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_record')
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id)
        get 'show', {:use_route => :customerx, :customer_id => cust.id, :id => rec.id}
        response.should be_success
      end
      
      it "should reject for users without right" do
        cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        role = FactoryGirl.create(:role_definition)
        user_access1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_customers', :role_definition_id => role.id, :rank => 1, :sql_code => '')
        user_access = FactoryGirl.create(:user_access, :action => 'unknow-show', :resource => 'customerx_customer_comm_records', :role_definition_id => role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=content'])
        ur = FactoryGirl.create(:user_role, :role_definition_id => role.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
        session[:employee] = true
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        c_cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_comm_record')
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :comm_category_id => c_cate.id, :reported_by_id => u.id)
        get 'show', {:use_route => :customerx, :customer_id => cust.id, :id => rec.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=show and resource=customerx/customer_comm_records")
      end
    end
  
  end
end
