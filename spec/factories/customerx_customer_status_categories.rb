# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer_status_category, :class => 'Customerx::CustomerStatusCategory' do
    cate_name "order customer"
    brief_note "for those cusotmers who order"
    active true
    last_updated_by_id 1
  end
end
