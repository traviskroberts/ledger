# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recurring_transaction do
    account
    day '25'
    description 'This is a test transaction.'
    float_amount '45.41'
  end
end
