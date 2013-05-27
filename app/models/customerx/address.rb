# encoding: utf-8
module Customerx
  class Address < ActiveRecord::Base
    
    attr_accessor :province_noupdate
    attr_accessible :add_line, :city_county_district, :province, :customer_id, :as => :role_new
    attr_accessible :add_line, :city_county_district, :province, :customer_id, :as => :role_update
    
    belongs_to :customer, :class_name => "Customerx::Customer"
    validates_presence_of :add_line , :message => '填地址门牌号码！'
    validates_presence_of :city_county_district,  :message => '不能为空！'
    validates_presence_of :province  , :message => '选择省份！'
  end
end
