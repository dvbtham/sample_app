class UserMailer < ApplicationMailer
  default from: Settings.no_reply_mail

  def account_activation user
    @user = user
    mail to: user.email, subject: t("account_activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("password_reset")
  end
end
