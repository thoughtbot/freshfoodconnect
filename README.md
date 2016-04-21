# Freshfoodconnect

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
