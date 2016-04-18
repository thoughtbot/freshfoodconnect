class PickupChecklist < SimpleDelegator
  delegate :zipcode, to: :zone

  def donations
    super.confirmed
  end

  def date
    start_at.to_date
  end
end
