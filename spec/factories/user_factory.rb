# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    sequence(:email) { |n| "user_#{n}@email.com" }
    password 'test1234'
    password_confirmation 'test1234'
    super_admin false
  end
end
