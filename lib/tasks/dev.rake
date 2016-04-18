if Rails.env.development? || Rails.env.test?
  require "factory_girl"

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: "db:setup" do
      include FactoryGirl::Syntax::Methods

      zone = create(
        :zone,
        zipcode: "80205",
        start_hour: 13,
        end_hour: 15,
        weekday: Date::DAYNAMES.index("Friday"),
      )
      registration = create(
        :registration,
        name: "Admin User",
        email: "admin@example.com",
        password: "password",
        zipcode: zone.zipcode,
      )
      registration.user.update!(admin: true)
      create(
        :registration,
        address: "2300 Steele St, Denver, CO",
        name: "Jane Q. Donor",
        email: "donor@example.com",
        password: "password",
        zipcode: zone.zipcode,
      )
      create(
        :cyclist,
        email: "cyclist@example.com",
        password: "password",
      )
    end
  end
end
