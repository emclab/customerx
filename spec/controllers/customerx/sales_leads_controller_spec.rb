require 'spec_helper'

module Customerx
  describe SalesLeadsController do

    before(:each) do
      controller.should_receive(:require_signin)
    end
  
    render_views
    
    before(:each) do
      @cate = FactoryGirl.create(:misc_definition, :for_which => 'customer_status', :name => 'order category')
      @z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => @z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
    end
      
    describe "GET 'index'" do
      it "should returns lead for user's own" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::SalesLead.where('lead_date > ?', 2.years.ago).
          where(:customer_id => Customerx::Customer.where(:sales_id => session[:user_id]).select('id')).
          order('lead_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        get 'index' , {:use_route => :customerx}
        assigns(:sales_leads).should eq([lead])        
      end
      
      it "should display only the sales leads for @customer if @customer present" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::SalesLead.where('lead_date > ?', 2.years.ago).
          where(:customer_id => Customerx::Customer.where(:sales_id => session[:user_id]).select('id')).
          order('lead_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        cust1 = FactoryGirl.create(:customer, :active => false, :name => 'new new name', :short_name => 'shoort name', 
                                   :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        lead1 = FactoryGirl.create(:sales_lead, :customer_id => cust1.id, :lead_info => 'a new lead')
        get 'index' , {:use_route => :customerx, :customer_id => cust1.id}
        assigns(:sales_leads).should eq([lead1])                
      end
      
      it"should reject for users without right" do
        user_access = FactoryGirl.create(:user_access, :action => 'no-index', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::SalesLead.where('lead_date > ?', 2.years.ago).
          where(:customer_id => Customerx::Customer.where(:sales_id => session[:user_id]).select('id')).
          order('lead_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)
        get 'index' , {:use_route => :customerx}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=index and resource=customerx/sales_leads")                  
      end
    end
  
    describe "GET 'new'" do
      it "returns http success for user with proper right" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.build(:sales_lead, :customer_id => cust.id)        
        get 'new', {:use_route => :customerx, :customer_id => cust.id}
        response.should be_success
      end
      
      it "should redirect user without proper right" do
        user_access = FactoryGirl.create(:user_access, :action => 'no-create', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.build(:sales_lead, :customer_id => cust.id)        
        get 'new', {:use_route => :customerx, :customer_id => cust.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=new and resource=customerx/sales_leads")       
      end
      
    end
  
    describe "GET 'create'" do
      it "should be OK for users with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.attributes_for(:sales_lead, :customer_id => cust.id)   
        get 'create', {:use_route => :customerx, :customer_id => cust.id, :sales_lead => lead}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Sales Lead Saved!")
      end
      
      it "should render template new if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.attributes_for(:sales_lead, :customer_id => cust.id, :subject => nil, )        
        get 'create', {:use_route => :customerx, :customer_id => cust.id}
        response.should render_template("new")
      end
      
    end
  
    describe "GET 'edit'" do
      it "returns http success for users with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)  
        get 'edit', {:use_route => :customerx, :customer_id => cust.id, :id => lead.id}
        response.should be_success
      end
      
      it "should display error if no customer provided for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)  
        get 'edit', {:use_route => :customerx, :id => lead.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Missing Customer!")
      end
    end
  
    describe "GET 'update'" do
      it "should be OK uses with rights" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)  
        get 'update', {:use_route => :customerx, :customer_id => cust.id, :id => lead.id, :sales_lead => {:lead_info => 'there is some changes', :subject => 'a new subject'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Sales Lead Updated!")
      end
      
      it "should redirec to edit page with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id)  
        get 'update', {:use_route => :customerx, :customer_id => cust.id, :id => lead.id, :sales_lead => {:lead_info => nil, :subject => 'a new subject'}}
        response.should render_template('edit')
      end
 
    end
  
    describe "GET 'show'" do
      it "returns success for users with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_sales_leads', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        ls = FactoryGirl.create(:misc_definition, :for_which => 'sales_lead_source')
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        lead = FactoryGirl.create(:sales_lead, :customer_id => cust.id, :lead_source_id => ls.id)  
        get 'show', {:use_route => :customerx, :customer_id => cust.id, :id => lead.id}
        response.should be_success
      end
    end
  
  end
end
