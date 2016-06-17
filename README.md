# Freshfoodconnect

[Fresh Food Connect] is an on-demand food donation and delivery web-application
focused on increasing access to healthy food and reducing food waste. Gardeners
or other folks with extra food sign up on the app and request for their excess
to be picked up and delivered by the app administrators. The founding
administrators, Groundwork Denver, Denver Food Rescue, and Denver Urban Gardens,
three nonprofits in Denver, CO, use bicycles, trailers and youth employees to
make pick up the excess food. Then, the food is delivered to free grocery
programs and low-cost farmers markets in low-income neighborhoods.

The app has three user types, admins, cyclists, and gardeners. Gardeners can
sign up for food delivery and set their locaiton as well as indicate how much
and what type of food they have for delivery. Cyclists then log on to the app to
view the upcoming pick ups and update a delivery report as each pick up is
completed. Admins can set the upcoming food pick up times and create cyclist and
admin profiles. These profiles work together to give gardeners an easy way to
make sure their home-grown food doesn't go to waste while increasing access to
local produce in low-income areas.

The initial version built to pilot the program was originally written by [Code
For Denver]. The following repositories contain that code: [API] and [Front End]

The production version was built by [thoughtbot, inc] and was funded via a grant
from the [Rose Foundation].

[Fresh Food Connect]: https://freshfoodconnect.org
[Code For Denver]: http://www.codefordenver.org/
[thoughtbot, inc]: https://thoughtbot.com
[API]: http//github.com/codefordenver/fresh-food-connect-api
[Front End]: https://github.com/codefordenver/fresh-food-connect
[Rose Foundation]: http://rosefdn.org/

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

After setting up, you can run the application using [Heroku Local]:

    % heroku local

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

Local development has access to the following user roles:

<dl>
  <dt>An administrator</dt>
  <dd>admin@example.com</dt>

  <dt>A donor</dt>
  <dd>donor@example.com</dt>

  <dt>A cyclist</dt>
  <dd>cyclist@example.com</dt>
</dl>

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production

## Scheduling Pickups

Our [staging][] and [production][] applications are deployed to Heroku.

We use the [Heroku Scheduler][scheduler] addon to run our scheduling-focussed
Rake tasks on a nightly basis.

Each night, the scheduler will run the following tasks:

* `pickups:schedule` - creates `ScheduledPickup` rows for any active
  zipcodes without pickups scheduled for the week. This task is idempotent.
* `confirmations:request` - sends Confirmation Request emails to donors
  associated with `ScheduledPickup`s scheduled to occur within the next `48`
  hours.

## Geocoding Locations

To geocode all locations that are missing `latitude` or `longitude` values:

```bash
$ rake locations:geocode
```

[staging]: https://dashboard.heroku.com/apps/freshfoodconnect-staging
[production]: https://dashboard.heroku.com/apps/freshfoodconnect-production
[scheduler]: https://elements.heroku.com/addons/scheduler

## Contributing

If you'd like to contribute a feature or bugfix: Thanks! To make sure your
fix/feature has a high chance of being included, please read the following
guidelines:

1. Post a [pull request](https://github.com/thoughtbot/freshfoodconnect/compare/).
2. Make sure there are tests! We will not accept any patch that is not tested.
   It's a rare time when explicit tests aren't needed. If you have questions
   about writing tests for Fresh Food Connect, please open a
   [GitHub issue](https://github.com/thoughtbot/freshfoodconnect/issues).

Please see [`CONTRIBUTING.md`](./CONTRIBUTING.md) for more details on
contributing and running test.

## License

Fresh Food Connect is Copyright © 2016 Ground Work Denver, Denver Food Rescue and
Denver Urban Gardens. It is free software, and may be redistributed under the
terms specified in the MIT-LICENSE file

## About thoughtbot

![thoughtbot](https://thoughtbot.com/logo.png)

We love open source software!
See [our other projects][community] or
[hire us][hire] to design, develop, and grow your product.

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com?utm_source=github
