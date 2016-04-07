class DonorEnrollment
  def initialize(location:)
    @location = location
  end

  def save!
    if donation.valid?
      donation.save!
    end
  end

  def donation
    @donation ||= Donation.find_or_initialize_by(
      location: location,
      scheduled_pickup: zone.current_scheduled_pickup,
    )
  end

  private

  delegate(:zone, to: :location)

  attr_reader :location
end
