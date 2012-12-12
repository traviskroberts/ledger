# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    account
    user
    sequence(:email) { |n| "person_#{n}@email.com" }
    sequence(:token) { |n| "xk39skj84x#{n}" }
  end
end
