module DonorsHelper
  def on_site?(donor)
    if donor.location.grown_on_site?
      I18n.t("donors.show.grown_on_site")
    else
      I18n.t("donors.show.grown_off_site")
    end
  end
end
