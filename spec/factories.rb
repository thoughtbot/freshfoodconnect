FactoryGirl.define do
  sequence(:email) { |i| "user#{i}@example.com" }

  trait :supported do
    zipcode Location::SUPPORTED_ZIPCODES.first
  end

  trait :unsupported do
    zipcode "90210"
  end

  factory :location do
    address "123 Fake Street"

    user

    supported
  end

  factory :registration do
    address "123 Fake Street"
    name "New User"
    password "password"

    supported
    email
  end

  factory :user do
    email
    password "password"

    factory :donor do
      location
    end
  end
end
