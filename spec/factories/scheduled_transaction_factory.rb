# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :scheduled_transaction do
    account
    day 25
    amount 4541
  end
end
