require 'spec_helper'

module Customerx
  describe Contact do
    it "should be OK" do
      i = FactoryGirl.build(:contact)
      i.should be_valid
    end
    
    it "should reject nil name" do
      i = FactoryGirl.build(:contact, :name => nil)
      i.should_not be_valid
    end
    
    it "should reject duplicate name for the same customer" do
      i = FactoryGirl.create(:contact, :name => "nil", :email => nil)
      i1 = FactoryGirl.build(:contact, :name => "Nil", :email => nil)
      i1.should_not be_valid
    end
    
    it "should be OK to duplicate name for different customers" do
      i = FactoryGirl.create(:contact, :name => "nil", :email => nil)
      i1 = FactoryGirl.build(:contact, :name => "Nil", :customer_id => i.customer_id + 1)
      i1.should be_valid
    end
    
    it "should reject duplicate email" do
      i = FactoryGirl.create(:contact, :email => "nil@nil.com")
      i1 = FactoryGirl.build(:contact, :email => "Nil@Nil.com")
      i1.should_not be_valid
    end
  end
end
