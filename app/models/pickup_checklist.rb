class PickupChecklist < SimpleDelegator
  delegate :zipcode, to: :zone

  def donations
    super.confirmed.order(created_at: :asc)
  end
end
