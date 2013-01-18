# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sys_user_group, class: 'Authentify::SysUserGroup'  do
    user_group_name "MyString"
    user_type_code 1
    user_type_desp 'employee'
    short_note "MyString"
  end
end
