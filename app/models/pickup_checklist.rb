class PickupChecklist < SimpleDelegator
  def donations
    super.confirmed
  end

  def date
    start_at.to_date
  end
end
