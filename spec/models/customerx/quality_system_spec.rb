require 'spec_helper'

module Customerx
  describe QualitySystem do
    it "should be OK" do
      c = FactoryGirl.build(:quality_system)
      c.should be_valid
    end
    
    it "should reject nil cate name" do
      c = FactoryGirl.build(:quality_system, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate cate name" do
      c1 = FactoryGirl.create(:quality_system)
      c2 = FactoryGirl.build(:quality_system, :brief_note => 'a dup cate name')
      c2.should_not be_valid
    end
  end
end
