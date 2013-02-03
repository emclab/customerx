# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comm_category, :class => 'Customerx::CommCategory' do
    name "tech support"
    brief_note "techincal issue"
    active true
    ranking_order 1
    last_updated_by_id 1
  end
end
