class UserMailer < ApplicationMailer

  def user_forgot_password(email, otp)
    @otp = otp
    @email=  email
    mail(to: @email, subject: 'Forgot Password For Memee' )
  end

  def winner_email(user,email,coins,card,rank)
    @user = user
    @email=  email
    @coins =coins
    @card= card
    @rank =rank
    mail(to: @email, subject: 'Winner' )
  end
  def winner_email_for_coin(user,email,coins,rank)
    @user = user
    @email=  email
    @coins =coins
    @rank =rank
    mail(to: @email, subject: 'Winner' )
  end

  def reward_payout(user,email,coins,card)
    @user = user
    @email=  email
    @coins =coins
    @card= card
    mail(to: @email, subject: 'Winner' )
  end

end
