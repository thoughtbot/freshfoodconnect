module ZonesHelper
  def zone_defaults(zone)
    start_hour = Hour.find(zone.start_hour)
    end_hour = Hour.find(zone.end_hour)
    weekday = Weekday.find(zone.weekday)

    t(
      ".prompt",
      zipcode: zone.zipcode,
      start: start_hour.label,
      end: end_hour.label,
      day: weekday.label,
    )
  end

  def subscriptions_count(zipcode)
    Subscription.where(zipcode: zipcode).count
  end
end
