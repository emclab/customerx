require 'spec_helper'

module Customerx
  describe CommRecordLogsController do
    
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
    end
  
    render_views
    
    describe "GET 'index'" do
      it "should be OK for index_individual with customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_record_logs', :action => 'index_individual')
        ua1 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_record_logs', :action => 'index')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ur1 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug1.id, :sys_action_on_table_id => ua1.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        ul1 = FactoryGirl.build(:user_level, :sys_user_group_id => ug1.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        u1 = FactoryGirl.create(:user, :user_levels => [ul1], :email => "a@bbb.com", :name => 'newnew', :login => 'newnewguy')
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        cust1 = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u1.id, :customer_status_category_id => cate.id, :name => "newname",
                                   :short_name => 'dontdup', :email => 'new@email.com', :sales_id => u1.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        rec1 = FactoryGirl.create(:customer_comm_record, :customer_id => cust1.id, :content => 'something different')
        log = FactoryGirl.create(:comm_record_log, :customer_comm_record_id => rec.id)
        log1 = FactoryGirl.create(:comm_record_log, :customer_comm_record_id => rec1.id, :log => 'give me something neew')
        get 'index', {:use_route => :customerx, :customer_comm_record_id => rec.id}
        response.should be_success
        assigns(:comm_record_logs).should eq([log])
      end
      
      it "should list logs for index_individual with no customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_record_logs', :action => 'index_individual')
        ua1 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_record_logs', :action => 'index')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ur1 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug1.id, :sys_action_on_table_id => ua1.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        ul1 = FactoryGirl.build(:user_level, :sys_user_group_id => ug1.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        u1 = FactoryGirl.create(:user, :user_levels => [ul1], :email => "a@bbb.com", :name => 'newnew', :login => 'newnewguy')
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        rec1 = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id, :content => 'something different')
        log = FactoryGirl.create(:comm_record_log, :customer_comm_record_id => rec.id)
        log1 = FactoryGirl.create(:comm_record_log, :customer_comm_record_id => rec1.id, :log => 'give me something neew')
        get 'index', {:use_route => :customerx}
        response.should be_success
        assigns(:comm_record_logs).should eq([log1,log])
      end
      
      it "should list all logs for index user with no customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_record_logs', :action => 'index')
        ua1 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_record_logs', :action => 'index_individual')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ur1 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug1.id, :sys_action_on_table_id => ua1.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        ul1 = FactoryGirl.build(:user_level, :sys_user_group_id => ug1.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        u1 = FactoryGirl.create(:user, :user_levels => [ul1], :email => "a@bbb.com", :name => 'newnew', :login => 'newnewguy')
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        cust1 = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u1.id, :customer_status_category_id => cate.id, :name => "newname",
                                   :short_name => 'dontdup', :email => 'new@email.com', :sales_id => u1.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        rec1 = FactoryGirl.create(:customer_comm_record, :customer_id => cust1.id, :content => 'something different')
        log = FactoryGirl.create(:comm_record_log, :customer_comm_record_id => rec.id)
        log1 = FactoryGirl.create(:comm_record_log, :customer_comm_record_id => rec1.id, :log => 'give me something neew')
        get 'index', {:use_route => :customerx}
        assigns(:comm_record_logs).should eq([log1, log])
      end
      
      it "should list logs for index user with a customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_record_logs', :action => 'index')
        ua1 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_record_logs', :action => 'index_individual')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ur1 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug1.id, :sys_action_on_table_id => ua1.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        ul1 = FactoryGirl.build(:user_level, :sys_user_group_id => ug1.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        u1 = FactoryGirl.create(:user, :user_levels => [ul1], :email => "a@bbb.com", :name => 'newnew', :login => 'newnewguy')
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        cust1 = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u1.id, :customer_status_category_id => cate.id, :name => "newname",
                                   :short_name => 'dontdup', :email => 'new@email.com', :sales_id => u1.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        rec1 = FactoryGirl.create(:customer_comm_record, :customer_id => cust1.id, :content => 'something different')
        log = FactoryGirl.create(:comm_record_log, :customer_comm_record_id => rec.id)
        log1 = FactoryGirl.create(:comm_record_log, :customer_comm_record_id => rec1.id, :log => 'give me something neew')
        get 'index', {:use_route => :customerx, :customer_comm_record_id => rec.id}
        assigns(:comm_record_logs).should eq([log])
      end
      
      it "should reject users without right with no customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_record_logs', :action => 'unknowindex_individual')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        log = FactoryGirl.create(:comm_record_log, :customer_comm_record_id => rec.id)
        get 'index', {:use_route => :customerx}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
      
      it "should reject users with no right with customer_comm_record" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ug1 = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales', :manager_group_id => ug.id, :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_comm_record_logs', :action => 'unknowindex_individual')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id, :matching_column_name => 'sales_id')
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id, :sales_id => u.id)
        rec = FactoryGirl.create(:customer_comm_record, :customer_id => cust.id)
        log = FactoryGirl.create(:comm_record_log, :customer_comm_record_id => rec.id)
        get 'index', {:use_route => :customerx, :customer_comm_record_id => rec.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        get 'new'
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns http success" do
        get 'create'
        response.should be_success
      end
    end
  
  end
end
