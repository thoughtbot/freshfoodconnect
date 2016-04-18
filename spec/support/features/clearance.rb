module Features
  def sign_in_as(user)
    visit("/")

    click_on t("application.header.sign_in")

    fill_form_and_submit(:session, email: user.email, password: user.password)
  end
end
