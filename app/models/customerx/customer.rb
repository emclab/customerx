module Customerx
  class Customer < ActiveRecord::Base
    attr_accessible :active, :customer_eval, :customer_status_category_id, :customer_taste, :employee_num, :fax, 
                    :last_updated_by_id, :main_biz, :name, :note, :phone, :zone_id, :shipping_instruction, :web,
                    :quality_system_id, :revenue, :sales_id, :short_name, :since_date, :address_attributes, :contacts_attributes,
                    :as => :role_new
    attr_accessible :active, :customer_eval, :customer_status_category_id, :customer_taste, :employee_num, :fax, 
                    :last_updated_by_id, :main_biz, :name, :note, :phone, :zone_id, :shipping_instruction, :web,
                    :quality_system_id, :revenue, :sales_id, :short_name, :since_date, :address_attributes,:contacts_attributes,
                    :as => :role_update
                    
    belongs_to :quality_system, :class_name => 'Customerx::QualitySystem'
    belongs_to :customer_status_category, :class_name => 'Customerx::CustomerStatusCategory'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :zone, :class_name => 'Authentify::Zone'
    belongs_to :sales, :class_name => 'Authentify::User'
    has_many :sales_leads, :class_name => 'Customerx::SalesLead'
    has_many :customer_comm_records, :class_name => 'Customerx::CustomerCommRecord'
    has_many :users, :class_name => "Authentify::User"
    has_one :address, :class_name => "Customerx::Address"
    has_many :contacts, :class_name => "Customerx::Contact"
    accepts_nested_attributes_for :address  #validates in address.rb works.
    accepts_nested_attributes_for :contacts, :allow_destroy => true
    #validates_presence_of  :address #not needed as validates in address.rb works
    
    #email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :message => 'Duplicate name'}
    validates :short_name, :presence => true, 
                           :uniqueness => {:case_sensitive => false, :message => 'Duplicate name'}
    validates_presence_of :phone, :fax, :zone_id, :sales_id, :since_date, :customer_status_category_id
    #validates :email, :format => { :with => email_regex, :message => 'Wrong email address!' , :unless => 'email.blank?' },
                  #    :uniqueness => {:case_sensitive => false, :unless => 'email.blank?', :message => 'Duplicate email address!' }
                      
    scope :active_cust, where(:active => true)
    scope :inactive_cust, where(:active => false)
    
    def find_customers
      customers = Customerx::Customer.active_cust
      customers
    end
                    
  end
end
