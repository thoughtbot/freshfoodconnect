module DonorsHelper
  def on_site?(donor)
    if donor.location.grown_on_site
      t(".grown_on_site")
    else
      t(".grown_of_site")
    end
  end
end
