# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sales_lead, :class => 'Customerx::SalesLead' do
    customer_id 1
    last_updated_by_id 1
    lead_info "plan to buy a CT within a year"
    contact_instruction "contact a guy with phone xxxx"
    lead_source "meeting"
    lead_quality 1
    provider_id 1
    lead_accuracy 1
    lead_eval 'a good eval'
    lead_status 'in working'
  end
end
