module DonorsHelper
  def on_site?(donor)
    if donor.location.grown_on_site?
      I18n.t(".grown_on_site")
    else
      I18n.t(".grown_off_site")
    end
  end
end
