module Customerx
  class Contact < ActiveRecord::Base
    attr_accessible :brief_note, :cell_phone, :email, :name, :phone, :position, :as => :role_new
    attr_accessible :brief_note, :cell_phone, :email, :name, :phone, :position, :as => :role_update
    
    belongs_to :customer, :class_name => 'Customerx::Customer'
    
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :name, :presence => true,
                     :uniqueness => {:case_sensitive => false, :scope => :customer_id, :message => 'Duplicate name'}
    validates :email, :format => { :with => email_regex, :message => 'Wrong email address!' , :unless => 'email.blank?' },
                      :uniqueness => {:case_sensitive => false, :unless => 'email.blank?', :message => 'Duplicate email address!' }
    
  end
end
