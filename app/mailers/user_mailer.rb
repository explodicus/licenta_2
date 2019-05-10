class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_confirmation.subject
  #
  def account_confirmation(user)
    @user = user
    mail to: user.email, subject: 'Account confirmed'
  end

  def child_account_confirmation(user)
    @user = user
    mail to: user.email, subject: 'Child account confirmed'
  end
end
