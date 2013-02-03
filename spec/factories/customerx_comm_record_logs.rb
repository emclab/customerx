# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comm_record_log, :class => 'Customerx::CommRecordLog' do
    customer_comm_record_id 1
    log "comm log"
    last_updated_by_id 1
    void false
  end
end
