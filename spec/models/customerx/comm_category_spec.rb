require 'spec_helper'

module Customerx
  describe CommCategory do
    it "should be OK" do
      c = FactoryGirl.build(:comm_category)
      c.should be_valid
    end
    
    it "should reject nil cate name" do
      c = FactoryGirl.build(:comm_category, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate cate name" do
      c1 = FactoryGirl.create(:comm_category)
      c2 = FactoryGirl.build(:comm_category, :brief_note => 'a dup cate name')
      c2.should_not be_valid
    end
  end
end
