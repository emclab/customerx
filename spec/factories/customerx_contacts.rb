# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact, :class => 'Customerx::Contact' do
    customer_id 1
    name "MyString"
    position "MyString"
    phone "MyString"
    cell_phone "MyString"
    email "bad@email.com"
    brief_note "MyText"
  end
end
