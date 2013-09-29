require 'spec_helper'

module Customerx
  describe CustomersController do
    before(:each) do
      controller.should_receive(:require_signin)
      #ActionView::Template.any_instance.stub(:refresh) #see http://stackoverflow.com/questions/18774400/how-to-set-virtual-path-true-in-refresh-in-actionviewtemplate
      #controller.should_receive(:require_employee)
    end
  
    render_views
    
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_status', :name => 'order category')
      @z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => @z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      eng_config = FactoryGirl.create(:engine_config, :argument_name => 'sales_lead', :argument_value => 'true', :engine_name => 'customerx')
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customerx', :engine_version => nil, :argument_name => 'customer_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('customer_show_view', 'customerx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'customerx', :engine_version => nil, :argument_name => 'customer_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('customer_index_view', 'customerx'))
      search_stat_info = FactoryGirl.create(:commonx_search_stat_config) 
    end
    
    describe "GET 'index'" do
      it "returns active customers list for user with index right" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::Customer.where(:active => true).order('active DESC, zone_id, id DESC, since_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        cust1 = FactoryGirl.create(:customer, :active => false, :name => 'new new name', :short_name => 'shoort name', 
                                   :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        get 'index' , {:use_route => :customerx}
        assigns(:customers).should eq([cust])
      end 
      
      it "returns active/inactive customers list for user of manager right" do
        
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::Customer.order('active DESC, zone_id, id DESC, since_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        cust1 = FactoryGirl.create(:customer, :active => false, :name => 'new new name', :short_name => 'shoort name', 
                                   :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        get 'index' , {:use_route => :customerx}
        assigns(:customers).should eq([cust, cust1])
      end  
      
      it "only return sales' customer for index_individual right" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::Customer.where(:sales_id => session[:user_id]).order('active DESC, zone_id, id DESC, since_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :sales_id => @u.id)
        cust1 = FactoryGirl.create(:customer, :active => false, :name => 'new new name', :short_name => 'shoort name', 
                                   :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :sales_id => @u.id)
        get 'index' , {:use_route => :customerx}
        assigns(:customers).should eq([cust, cust1])
      end
      
      it "only return sales' active customer for index_individual right without activate right" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::Customer.where(:active => true).where(:sales_id => session[:user_id]).order('active DESC, zone_id, id DESC, since_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :sales_id => @u.id)
        cust1 = FactoryGirl.create(:customer, :active => false, :name => 'new new name', :short_name => 'shoort name', 
                                   :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :sales_id => @u.id)
        get 'index' , {:use_route => :customerx}
        assigns(:customers).should eq([cust])
      end
      
      it "only return active customer which belongs to zone for index_zone" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::Customer.where(:active => true).
        where(:sales_id => Authentify::UserLevel.joins(:sys_user_group).where(:authentify_sys_user_groups => {:zone_id => session[:user_privilege].user_zone_ids}).select('user_id')).
        order('active DESC, zone_id, id DESC, since_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :sales_id => @u.id)
        cust1 = FactoryGirl.create(:customer, :active => false, :name => 'new new name', :short_name => 'shoort name', 
                                   :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :sales_id => @u.id)
        get 'index' , {:use_route => :customerx}
        assigns(:customers).should eq([cust])
      end
      
      it "should reject users without proper right" do
        user_access = FactoryGirl.create(:user_access, :action => 'unknown_index', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id)
        cust1 = FactoryGirl.create(:customer, :active => false, :name => 'new new name', :short_name => 'shoort name', 
                                   :last_updated_by_id => @u.id)
        get 'index' , {:use_route => :customerx}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=index and resource=customerx/customers")        
      end
                     
    end  
    
    describe "GET new" do
      it "should reject users without proper right" do
        user_access = FactoryGirl.create(:user_access, :action => 'unknown-create', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.attributes_for(:customer, :active => true, :last_updated_by_id => @u.id)
        get 'new' , {:use_route => :customerx}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=new and resource=customerx/customers")                
      end
      
      it "should new for user with proper right" do       
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.attributes_for(:customer, :active => true, :last_updated_by_id => @u.id)
        get 'new' , {:use_route => :customerx}   
        response.should be_success     
      end
    end
    
    describe "GET Create" do
      it "should create new customer for user right proper right" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        add = FactoryGirl.attributes_for(:address)
        contact = FactoryGirl.attributes_for(:contact)
        cust = FactoryGirl.attributes_for(:customer, :active => true, :last_updated_by_id => @u.id, :address_attributes => add, :contacts_attributes => [contact]) 
        get 'create', {:use_route => :customerx, :customer => cust}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")        
      end
      
      it "should render new if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        add = FactoryGirl.attributes_for(:address)
        contact = FactoryGirl.attributes_for(:contact)
        cust = FactoryGirl.attributes_for(:customer, :active => true, :last_updated_by_id => @u.id, :address_attributes => add, :contacts_attributes => [contact],
                                          :name => nil) 
        get 'create', {:use_route => :customerx, :customer => cust}
        response.should render_template("new")        
      end
      
      it "should render new if contact data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        add = FactoryGirl.attributes_for(:address)
        contact = FactoryGirl.attributes_for(:contact, :name => nil)
        cust = FactoryGirl.attributes_for(:customer, :active => true, :last_updated_by_id => @u.id, :address_attributes => add, :contacts_attributes => [contact]) 
        get 'create', {:use_route => :customerx, :customer => cust}
        response.should render_template("new")        
      end
      
      it "should render new if address data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        add = FactoryGirl.attributes_for(:address, :add_line => nil)
        contact = FactoryGirl.attributes_for(:contact)
        cust = FactoryGirl.attributes_for(:customer, :active => true, :last_updated_by_id => @u.id, :address_attributes => add, :contacts_attributes => [contact]) 
        get 'create', {:use_route => :customerx, :customer => cust}
        response.should render_template("new")  
      end
     
    end
    
    describe "GET Edit" do
      it "should reject users without right" do
        user_access = FactoryGirl.create(:user_access, :action => 'unknow_edit', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id)
        get 'edit' , {:use_route => :customerx, :id => cust.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=edit and resource=customerx/customers") 
      end
      
      it "should edit for user with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id)
        get 'edit' , {:use_route => :customerx, :id => cust.id}
        response.should be_success
      end
    end
    
    describe "GET Update" do
      it "should update for user with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        add = FactoryGirl.build(:address)
        contact = FactoryGirl.build(:contact)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :address => add, :contacts => [contact]) 
        get 'update' , {:use_route => :customerx, :id => cust.id, :customer => {:name => 'newnew name', :customer_status_category_id => 2}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=name'])
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        add = FactoryGirl.build(:address)
        contact = FactoryGirl.build(:contact)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :address => add, :contacts => [contact]) 
        get 'update' , {:use_route => :customerx, :id => cust.id, :customer => {:zone_id => nil, :short_name => 'new short'}}
        response.should render_template('edit')
      end
      
      it "should render edit if address data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=name'])
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        add = FactoryGirl.build(:address)
        contact = FactoryGirl.build(:contact)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :address => add, :contacts => [contact]) 
        get 'update' , {:use_route => :customerx, :id => cust.id, :customer => {:address_attributes => {:province => nil}}}
        response.should render_template('edit')
      end
      
      it "should render edit if contact data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "", :masked_attrs => ['=name'])
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        add = FactoryGirl.build(:address)
        contact = FactoryGirl.build(:contact)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :address => add, :contacts => [contact]) 
        get 'update' , {:use_route => :customerx, :id => cust.id, :customer => {:contacts_attributes => {'1' =>{:name => nil}}}}
        response.should render_template('edit')
      end
    end
    
    describe "GET show" do
      it "should show for user with right" do
        add = FactoryGirl.create(:address)
        qs = FactoryGirl.create(:commonx_misc_definition, :for_which => 'customer_qs')
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id, :quality_system_id => qs.id,
                                             :zone_id => @z.id, :address => add)
        get 'show' , {:use_route => :customerx, :id => cust.id}
        response.should be_success
      end
    end
    
    describe "GET search" do
            
      it "should search for users with right" do
        user_access = FactoryGirl.create(:user_access, :action => 'search', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::Customer.scoped")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'search', {:use_route => :customerx}
        response.should be_success
      end
    end
    
    describe "GET search_results" do
      it "should return search results" do
         user_access = FactoryGirl.create(:user_access, :action => 'search', :resource => 'customerx_customers', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "Customerx::Customer.scoped")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        cust = FactoryGirl.create(:customer, :active => true, :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        cust1 = FactoryGirl.create(:customer, :active => false, :name => 'new new name', :short_name => 'shoort name', 
                                   :last_updated_by_id => @u.id, :customer_status_category_id => @cate.id)
        get 'search_results', {:use_route => :customerx, :customer => {:zone_id_s => @z.id}}
        assigns(:s_s_results_details).models.should =~ [cust, cust1]   
      end
    end
    
  end
end
