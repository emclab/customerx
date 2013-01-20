require 'spec_helper'

module Customerx
  describe SalesLeadsController do
  
    describe "GET 'index'" do
      it "returns http success" do
        cate = FactoryGirl.create(:customer_status_category, :cate_name => 'order category')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customers', :action => 'index')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        cust1 = FactoryGirl.create(:customer, :active => false, :name => 'new new name', :short_name => 'shoort name', 
                                   :email => 'email@example.com', :last_updated_by_id => u.id, :customer_status_category_id => cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        get 'index' , {:use_route => :customerx}
        assigns(:sales_leads).should eq([lead])        
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
  
    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit'
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "returns http success" do
        get 'update'
        response.should be_success
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should be_success
      end
    end
  
  end
end
