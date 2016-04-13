class Confirmation < SimpleDelegator
  def confirm!
    update!(confirmed: true)
  end

  def decline!
    update!(declined: true)
  end

  def request!
    if pending? && unrequested?
      ConfirmationRequestJob.perform_now(donation: donation)
    end
  end

  alias donation __getobj__
end
