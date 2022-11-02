class UserMailer < ApplicationMailer

  def user_forgot_password(email, otp)
    @otp = otp
    @email=  email
    mail(to: @email, subject: 'Forgot Password For Memee' )
  end
end
