require 'spec_helper'

module Customerx
  describe CustomerStatusCategory do
    it "should be OK" do
      c = FactoryGirl.build(:customer_status_category)
      c.should be_valid
    end
    
    it "should reject nil cate name" do
      c = FactoryGirl.build(:customer_status_category, :cate_name => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate cate name" do
      c1 = FactoryGirl.create(:customer_status_category)
      c2 = FactoryGirl.build(:customer_status_category, :brief_note => 'a dup cate name')
      c2.should_not be_valid
    end
  end
end
