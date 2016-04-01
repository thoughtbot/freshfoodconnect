FactoryGirl.define do
  sequence(:email) { |i| "user#{i}@example.com" }
  sequence(:zipcode) { |i| i.to_s.rjust(5, "0") }

  factory :delivery_zone do
    zipcode
  end

  factory :location do
    address "123 Fake Street"

    user

    supported

    trait :supported do
      delivery_zone
    end

    trait :unsupported do
    end
  end

  factory :registration do
    address "123 Fake Street"
    name "New User"
    password "password"

    email
  end

  factory :user do
    email
    password "password"

    factory :donor do
      with_location
    end

    trait :admin do
      admin true
    end

    trait :with_location do
      location
    end
  end
end
