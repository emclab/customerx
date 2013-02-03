# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lead_log, :class => 'Customerx::LeadLog' do
    sales_lead_id 1
    log "check out "
    last_updated_by_id 1
    void false
  end
end
