FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.com" }
    password "password"

    supported

    trait :supported do
      zipcode "80221"
    end

    trait :unsupported do
      zipcode "90210"
    end
  end
end
