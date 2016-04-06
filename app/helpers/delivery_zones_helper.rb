module DeliveryZonesHelper
  def delivery_zone_defaults(delivery_zone)
    start_hour = Hour.find(delivery_zone.start_hour)
    end_hour = Hour.find(delivery_zone.end_hour)
    weekday = Weekday.find(delivery_zone.weekday)

    t(
      ".prompt",
      zipcode: delivery_zone.zipcode,
      start: start_hour.label,
      end: end_hour.label,
      day: weekday.label,
    )
  end
end
