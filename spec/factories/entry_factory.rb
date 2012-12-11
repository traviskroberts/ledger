# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    account
    description "Test Entry"
    classification "credit"
    float_amount "19.37"
  end
end
