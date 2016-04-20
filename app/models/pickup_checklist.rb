class PickupChecklist < SimpleDelegator
  delegate :zipcode, to: :zone

  def donations
    super.confirmed
  end
end
