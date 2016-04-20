class ActiveGuard < Clearance::SignInGuard
  def call
    if signed_in? && current_user.deleted?
      failure(I18n.t("validations.deactivated"))
    else
      next_guard
    end
  end
end
