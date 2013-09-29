module Customerx
  class Customer < ActiveRecord::Base
    attr_accessible :active, :customer_eval, :customer_status_category_id, :customer_taste, :employee_num, :fax, 
                    :last_updated_by_id, :main_biz, :name, :note, :phone, :zone_id, :shipping_instruction, :web,
                    :quality_system_id, :revenue, :sales_id, :short_name, :since_date, :address_attributes, :contacts_attributes,
                    :zone_name, :customer_status_category_name, :quality_system_name, :active_noupdate, :sales_name,
                    :as => :role_new
    attr_accessible :active, :customer_eval, :customer_status_category_id, :customer_taste, :employee_num, :fax, 
                    :last_updated_by_id, :main_biz, :name, :note, :phone, :zone_id, :shipping_instruction, :web,
                    :quality_system_id, :revenue, :sales_id, :short_name, :since_date, :address_attributes,:contacts_attributes,
                    :zone_name, :customer_status_category_name, :quality_system_name, :active_noupdate, :sales_name,
                    :as => :role_update
    
    attr_accessor :zone_name, :customer_status_category_name, :quality_system_name, :active_noupdate, :sales_name
    attr_accessor :customer_id_s, :start_date_s, :end_date_s, :keyword_s, :zone_id_s, :sales_id_s, :customer_status_category_id_s, :active_s
    attr_accessible :customer_id_s, :start_date_s, :end_date_s, :keyword_s, :zone_id_s, :sales_id_s, :customer_status_category_id_s, :active_s,
                    :as => :role_search_stats
                    
    belongs_to :quality_system, :class_name => 'Commonx::MiscDefinition'
    belongs_to :customer_status_category, :class_name => 'Commonx::MiscDefinition'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :zone, :class_name => 'Authentify::Zone'
    belongs_to :sales, :class_name => 'Authentify::User'
    has_many :sales_leads, :class_name => 'Customerx::SalesLead'
    has_many :customer_comm_records, :class_name => 'Customerx::CustomerCommRecord'
    has_many :users, :class_name => "Authentify::User"
    has_one :address, :class_name => "Customerx::Address"
    has_many :contacts, :class_name => "Customerx::Contact"
    #if defined? Projectx::Project
    #  has_many :projects, :class_name => 'Projectx::Project'
    #end
    accepts_nested_attributes_for :address  #validates in address.rb works.
    accepts_nested_attributes_for :contacts, :allow_destroy => true
    
    #validates_presence_of  :address #not needed as validates in address.rb works
    
    #email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validates :short_name, :presence => true, 
                           :uniqueness => {:case_sensitive => false, :message => I18n.t('Duplicate Name!')}
    validates_presence_of :phone, :fax, :zone_id, :sales_id, :since_date, :customer_status_category_id
    #validates :email, :format => { :with => email_regex, :message => 'Wrong email address!' , :unless => 'email.blank?' },
                  #    :uniqueness => {:case_sensitive => false, :unless => 'email.blank?', :message => 'Duplicate email address!' }
                      
    scope :active_cust, where(:active => true)
    scope :inactive_cust, where(:active => false)
    
    def find_customers
      #return all qualified customers
      customers = Customerx::Customer.scoped  #In Rails < 4 .all makes database call immediately, loads records and returns array. 
      #Instead use "lazy" scoped method which returns chainable ActiveRecord::Relation object
      customers = customers.where('created_at > ?', start_date_s) if start_date_s.present?
      customers = customers.where('created_at < ?', end_date_s) if end_date_s.present?
      customers = customers.where("name like ? OR short_name like ?", "%#{keyword}%", "%#{keyword}%") if keyword.present?
      customers = customers.where(:zone_id => zone_id_s) if zone_id_s.present?
      customers = customers.where("sales_id = ?", sales_id_s) if sales_id_s.present?
      customers = customers.where(:status_category_s => status_category_s) if status_category_s.present?
      customers = customers.where("id = ?", customer_id_s) if customer_id_s.present?
      customers
    end                   
  end
end
