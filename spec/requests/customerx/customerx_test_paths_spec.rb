require 'spec_helper'

describe "TestPaths" do
  describe "GET /customerx_test_paths" do
    before(:each) do
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
      ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customer_status_categories', :action => 'create')
      ua1 = FactoryGirl.create(:sys_action_on_table, :table_name => 'customerx_customer_status_categories', :action => 'update')
      ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
      ur1 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua1.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      u = FactoryGirl.create(:user, :user_levels => [ul])
      #session[:user_id] = u.id
      #session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
      @cate1 = FactoryGirl.create(:customer_status_category)
      @cate2 = FactoryGirl.create(:customer_status_category, :cate_name => 'newnew cate')
      visit 'authentify/'
      fill_in "login", :with => u.login
      fill_in "password", :with => 'password'
      click_button   
    end
    
    it "should display customer status category index page" do
      visit customer_status_categories_path
      response.should have_selector("title", :content => "Customerx")
    end
    
    it "should display quality system index page" do
      visit quality_systems_path
      response.should have_selector("title", :content => "Customerx")
    end
    
    it "should display edit page for the record" do
      visit edit_customer_status_category_path(@cate2)
      response.should have_selector("content", 'newnew cate')
    end
    
    it "should display new page" do
      visit new_customer_status_category_path
      response.should have_selector("title", "New Customer Status Category")
    end
    
  end
end
