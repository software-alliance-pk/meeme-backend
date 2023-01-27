class UserMailer < ApplicationMailer

  def user_forgot_password(email, otp)
    @otp = otp
    @email=  email
    mail(to: @email, subject: 'Forgot Password For Memee' )
  end

  def winner_email(email,coins,card,rank)
    @email=  email
    @coins =coins
    @card= card
    @rank =rank
    mail(to: @email, subject: 'Winner' )
  end
  def winner_email_for_coin(email,coins,rank)
    @email=  email
    @coins =coins
    @rank =rank
    mail(to: @email, subject: 'Winner' )
  end

end
