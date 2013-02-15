require 'spec_helper'

module Customerx
  describe Address do
    it "should be OK" do
      i = FactoryGirl.build(:address)
      i.should be_valid
    end
    
    it "should reject nil province" do
      i = FactoryGirl.build(:address, :province => nil)
      i.should_not be_valid
    end
  
    it "should reject nil city/county" do
      i = FactoryGirl.build(:address, :city_county_district => nil)
      i.should_not be_valid
    end
    
    it "should reject nil add_line" do
      i = FactoryGirl.build(:address, :add_line => nil)
      i.should_not be_valid
    end
  end
end
