# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lead_source, :class => 'Customerx::LeadSource' do
    name "lead source"
    active false
    ranking_order 1
    brief_note 'a note about lead source'
  end
end
