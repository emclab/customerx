require 'spec_helper'

module Customerx
  describe LeadSource do
    it "should be OK" do
      l = FactoryGirl.build(:lead_source)
      l.should be_valid
    end
    
    it "should reject nil name" do
      l = FactoryGirl.build(:lead_source, :name => nil)
      l.should_not be_valid
    end
    
  end
end
