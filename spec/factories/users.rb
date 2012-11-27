# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "MyString"
    crypted_password "MyString"
    password_salt "MyString"
    persistence_token "MyString"
    perishable_token "MyString"
    current_login_at "2012-11-26 19:00:04"
    last_login_at "2012-11-26 19:00:04"
    last_request_at "2012-11-26 19:00:04"
    login_count 1
    last_login_ip "MyString"
    current_login_ip "MyString"
  end
end
