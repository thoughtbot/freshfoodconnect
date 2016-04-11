FactoryGirl.define do
  sequence(:email) { |i| "user#{i}@example.com" }
  sequence(:zipcode) { |i| i.to_s.rjust(5, "0") }

  factory :donation do
    location
    pending
    scheduled_pickup
    unrequested

    trait :confirmed do
      confirmed true
    end

    trait :declined do
      declined true
    end

    trait :pending do
      confirmed false
      declined false
    end

    trait :requested do
      requested true
    end

    trait :unrequested do
      requested false
    end
  end

  factory :location do
    address "123 Fake Street"

    user

    supported

    trait :supported do
      zone
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

  factory :scheduled_pickup do
    current

    zone

    trait :current do
      start_at { Time.current + 1.hour }
      end_at { Time.current + 2.hour }
    end

    trait :past do
      start_at { 1.week.ago }
      end_at { 1.week.ago + 1.hour }
    end
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

  factory :zone do
    start_hour 0
    end_hour 0
    weekday 0

    unscheduled
    zipcode

    trait :unscheduled

    trait :with_scheduled_pickups do
      after(:create) do |zone|
        PickupScheduler.new(zone).schedule!
      end
    end
  end
end
