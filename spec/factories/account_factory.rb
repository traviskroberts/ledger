# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    name 'Test Account'
    initial_balance "$47.35"
  end
end
