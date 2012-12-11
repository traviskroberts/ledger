# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    account_id 1
    user_id 1
    email "MyString"
  end
end
