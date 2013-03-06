# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :log, :class => 'Customerx::Log' do
    customer_comm_record_id 1
    last_updated_by_id 1
    log "MyString log"
    which_table 'customer_comm_record'
  end
end
