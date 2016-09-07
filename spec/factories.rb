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

    trait :confirmed_then_declined do
      confirmed_at 1.week.ago
      declined_at 1.day.ago
    end

    trait :declined do
      declined true
    end

    trait :declined_then_confirmed do
      declined_at 1.week.ago
      confirmed_at 1.day.ago
    end

    trait :picked_up do
      confirmed

      picked_up true
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

    residence
    grown_on_site
    not_geocoded
    user

    supported

    trait :geocoded do
      latitude 40.0
      longitude 60.0
    end

    trait :grown_on_site do
      grown_on_site true
    end

    trait :not_geocoded do
      latitude nil
      longitude nil
    end

    trait :residence do
      location_type :residence
    end

    trait :supported do
      zone
    end

    trait :unsupported do
    end
  end

  factory :region do
    sequence(:name) { |i| "Region #{i}" }

    trait :with_zones do
      zones { build_list :zone, 2 }
    end
  end

  factory :region_admin do
    region { build(:region) }
    admin { build(:user) }
  end

  factory :registration do
    address "123 Fake Street"
    name "New User"
    password "password"
    organic_growth_asserted true
    terms_and_conditions_accepted true

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
    sequence(:name) { |i| "Jane the #{[i, i.ordinal].join}" }

    active
    email
    password "password"
    organic_growth_asserted true
    terms_and_conditions_accepted true

    factory :admin do
      admin true
    end

    factory :cyclist do
      cyclist true
    end

    factory :donor do
      with_location
    end

    trait :with_location do
      location
    end

    trait :active do
      deleted false
    end

    trait :deleted do
      deleted true
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
