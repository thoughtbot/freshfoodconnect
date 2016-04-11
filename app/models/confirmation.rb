class Confirmation
  def initialize(donation:)
    @donation = donation
  end

  def confirm!
    donation.update!(confirmed: true)
  end

  def decline!
    donation.update!(declined: true)
  end

  attr_reader :donation
end
