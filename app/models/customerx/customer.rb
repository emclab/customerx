module Customerx
  class Customer < ActiveRecord::Base
    attr_accessible :active, :address, :contact_info, :customer_eval, :customer_status_category_id, :customer_taste, :email, :employee_num, :fax, 
                    :last_updated_by_id, :main_biz, :name, :note, :phone, :zone_id, 
                    :quality_system_id, :revenue, :sales_id, :shipping_address, :short_name, :since_date, :as => :role_new
    attr_accessible :active, :address, :contact_info, :customer_eval, :customer_status_category_id, :customer_taste, :email, :employee_num, :fax, 
                    :last_updated_by_id, :main_biz, :name, :note, :phone, :zone_id, 
                    :quality_system_id, :revenue, :sales_id, :shipping_address, :short_name, :since_date, :as => :role_update
                    
    belongs_to :quality_system, :class_name => 'Customerx::QualitySystem'
    belongs_to :customer_status_category, :class_name => 'Customerx::CustomerStatusCategory'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :zone, :class_name => 'Authentify::Zone'
    belongs_to :sales, :class_name => 'Authentify::User'
    
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :message => 'Duplicate name'}
    validates :short_name, :presence => true, 
                           :uniqueness => {:case_sensitive => false, :message => 'Duplicate name'}
    validates_presence_of :contact_info, :address, :shipping_address, :phone, :fax, :zone_id, :sales_id, :since_date
    validates :email, :format => { :with => email_regex, :message => 'Wrong email address!' , :unless => 'email.nil?' },
                      :uniqueness => {:case_sensitive => false, :unless => 'email.nil?', :message => 'Duplicate email address!' }
                      
    scope :active_cust, where(:active => true)
    scope :inactive_cust, where(:active => false)
    
    def find_customers
      customers = Customerx::Customer.active_cust
      customers
    end
                    
  end
end
