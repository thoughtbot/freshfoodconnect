FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.com" }
    password "password"
    zipcode "80221"
  end
end
