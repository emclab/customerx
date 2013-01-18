# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quality_system, :class => 'Customerx::QualitySystem' do
    name "ISO9000"
    brief_note "ISO9000"
    active true
    last_updated_by_id 1
    ranking_order 1
  end
end
