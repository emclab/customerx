require 'spec_helper'

module Customerx
  describe Customer do
    it "should reject nil name" do
      c = FactoryGirl.build(:customer, :name => nil) 
      c.should_not be_valid
    end
    
    it "should reject nil short name" do
      c = FactoryGirl.build(:customer, :short_name => nil) 
      c.should_not be_valid
    end
    
    it "should reject nil address" do
      c = FactoryGirl.build(:customer, :address => nil) 
      c.should_not be_valid
    end    
     
    it "should reject nil shipping address" do
      c = FactoryGirl.build(:customer, :shipping_address => nil) 
      c.should_not be_valid
    end
    
    it "should reject nil contact info" do
      c = FactoryGirl.build(:customer, :contact_info => nil) 
      c.should_not be_valid
    end
    
    it "should reject nil zone id" do
      c = FactoryGirl.build(:customer, :zone_id => nil) 
      c.should_not be_valid
    end
    
    it "should reject nil sales id" do
      c = FactoryGirl.build(:customer, :sales_id => nil) 
      c.should_not be_valid
    end
    
    it "should reject nil phone" do
      c = FactoryGirl.build(:customer, :phone => nil) 
      c.should_not be_valid
    end
    
    it "should reject nil fax" do
      c = FactoryGirl.build(:customer, :fax => nil) 
      c.should_not be_valid
    end
    
    it "should reject nil date since" do
      c = FactoryGirl.build(:customer, :since_date => nil) 
      c.should_not be_valid
    end
    
    it "should reject duplidate name" do
      c = FactoryGirl.create(:customer, :name => 'test')
      c1 = FactoryGirl.build(:customer, :name => 'Test')
      c1.should_not be_valid
    end
    
    it "should reject duplidate short name" do
      c = FactoryGirl.create(:customer, :short_name => 'test')
      c1 = FactoryGirl.build(:customer, :short_name => 'Test')
      c1.should_not be_valid
    end
    
    it "should reject duplidate email" do
      c = FactoryGirl.create(:customer, :email => 'test@vip.sina.com')
      c1 = FactoryGirl.build(:customer, :email => 'Test@vip.sina.com')
      c1.should_not be_valid
    end
        
  end
end
