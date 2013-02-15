require 'spec_helper'

module Customerx
  describe Customer do
    
    it "should be OK" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer, address: add, :contacts => [contact]) 
      c.should be_valid
    end
    
    it "should reject nil name" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer, :name => nil, address: add, :contacts => [contact])
      c.should_not be_valid
    end
    
    it "should reject nil short name" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer, :short_name => nil, address: add, :contacts => [contact])
      c.should_not be_valid
    end
    
    it "should reject nil add" do
      add = FactoryGirl.build(:address, :province => nil, :city_county_district => nil, :add_line => nil)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer,  address: add, :contacts => [contact])
      c.should_not be_valid
    end  
    
    it "should reject nil province" do
      add = FactoryGirl.build(:address, :province => nil)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer,  address: add, :contacts => [contact])
      c.should_not be_valid
    end  
    
    it "should reject nil city" do
      add = FactoryGirl.build(:address, :city_county_district => nil)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer,  address: add, contacts: [contact] )
      c.should_not be_valid
    end 
    
    it "should reject nil add_line" do
      add = FactoryGirl.build(:address, :add_line => nil)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer,  address: add , :contacts => [contact])
      c.should_not be_valid
    end   
    
    it "should reject nil contact name info" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => '')
      c = FactoryGirl.build(:customer, :contacts => [contact], address: add) 
      c.should_not be_valid
    end
    
    it "should reject nil zone id" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer, :zone_id => nil, address: add, :contacts => [contact])
      c.should_not be_valid
    end
    
    it "should reject nil sales id" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer, :sales_id => nil, address: add, :contacts => [contact])
      c.should_not be_valid
    end
    
    it "should reject nil phone" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer, :phone => nil, address: add, :contacts => [contact])
      c.should_not be_valid
    end
    
    it "should reject nil fax" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer, :fax => nil, address: add, :contacts => [contact])
      c.should_not be_valid
    end
    
    it "should reject nil date since" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.build(:customer, :since_date => nil, address: add, :contacts => [contact])
      c.should_not be_valid
    end
    
    it "should reject duplidate name" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      c = FactoryGirl.create(:customer, :name => 'test', address: add)
      c1 = FactoryGirl.build(:customer, :name => 'Test', address: add)
      c1.should_not be_valid
    end
    
    it "should reject duplidate short name" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact, :name => 'a guy')
      contact1 = FactoryGirl.build(:contact, :name => 'a guy1', :email => nil)
      c = FactoryGirl.create(:customer, :short_name => 'test', address: add, :contacts => [contact] )
      c1 = FactoryGirl.build(:customer, :short_name => 'Test', address: add, contacts: [contact1] )
      c1.should_not be_valid
    end
    
    it "should reject nil customer status category" do
      add = FactoryGirl.build(:address)
      contact = FactoryGirl.build(:contact)
      c = FactoryGirl.build(:customer, :customer_status_category_id => nil, :since_date => nil, address: add, :contacts => [contact])
      c.should_not be_valid
    end
    
  end
end
