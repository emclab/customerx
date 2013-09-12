# encoding: utf-8
module Customerx
  class Address < ActiveRecord::Base
    
    attr_accessor :province_noupdate
    attr_accessible :add_line, :city_county_district, :province, :customer_id, 
                    :province_noupdate,
                    :as => :role_new
    attr_accessible :add_line, :city_county_district, :province, :customer_id, 
                    :province_noupdate,
                    :as => :role_update
    
    belongs_to :customer, :class_name => "Customerx::Customer"
    validates_presence_of :add_line , :message => I18n.t('Fill in address!')
    validates_presence_of :city_county_district,  :message => I18n.t('Can not be empty!')
    validates_presence_of :province  , :message => I18n.t('Choose province!')
  end
end
