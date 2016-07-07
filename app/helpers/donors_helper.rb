module DonorsHelper
  def is_or_isnt_on_site(donor)
    donor.location.grown_on_site ? "is" : "is not"
  end
end
