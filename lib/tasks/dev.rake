if Rails.env.development? || Rails.env.test?
  require "factory_girl"

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: "db:setup" do
      include FactoryGirl::Syntax::Methods

      create(
        :user,
        :admin,
        name: "Super User",
        email: "user@example.com",
        password: "password",
      )

      create(
        :delivery_zone,
        zipcode: "80205",
        start_hour: 13,
        end_hour: 15,
        weekday: Date::DAYNAMES.index("Thursday"),
      )
    end
  end
end
