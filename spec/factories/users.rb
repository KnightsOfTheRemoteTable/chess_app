FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.com" }
    password "supersecret"
    password_confirmation "supersecret"
  end
end
