require 'spec_helper'

module Customerx
  describe MiscDefinition do
    it "should be OK" do
      c = FactoryGirl.build(:misc_definition)
      c.should be_valid
    end
    
    it "should reject nil cate name" do
      c = FactoryGirl.build(:misc_definition, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate name for the same which_table" do
      c1 = FactoryGirl.create(:misc_definition)
      c2 = FactoryGirl.build(:misc_definition, :brief_note => 'a dup cate name')
      c2.should_not be_valid
    end
    
    it "should be OK for duplicate name for different which_table" do
      c1 = FactoryGirl.create(:misc_definition, :for_which => 'a strange')
      c2 = FactoryGirl.build(:misc_definition, :brief_note => 'a dup cate name')
      c2.should be_valid
    end
    
    it "should reject nil which_table" do
      c = FactoryGirl.build(:misc_definition, :for_which => nil)
      c.should_not be_valid
    end
  end
end
