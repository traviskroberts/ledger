# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    description "MyString"
    classification "MyString"
    amount 1
  end
end
