# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer_comm_record, :class => 'Customerx::CustomerCommRecord' do
    customer_id 1
    via "meeting"
    subject "new update"
    contact_info "a guy @1231"
    content "here is detail"
    last_updated_by_id 1
    comm_category_id 1
    reported_by_id 1
    comm_date "2013-01-27"
  end
end
