class UserMailer < ApplicationMailer

  def user_forgot_password(email, otp)
    @otp = otp
    @email=  email
    mail(to: @email, subject: 'Forgot Password' )
  end

  def user_forgot_password_web(email, otp)
    @otp = otp
    @email=  email
    @url = "#{ENV['FRONTEND_URL']}/restsetPassword?email=#{email}&otp=#{otp}"
    mail(to: @email, subject: 'Forgot Password' )
  end

  def winner_email(user,email,coins,card,rank)
    @user = user
    @email=  email
    @coins =coins
    @card= card
    @rank =rank
    mail(to: @email, subject: 'Winner' )
  end

  def flag_tournament_post(user,email)
    @email = email
    @user = user
    mail(to: @email, subject: 'Flagged Tournament Post' )
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

  def tournament_judged_coins(user, coins)
    @user = user
    @coins = coins
    mail(to: @user.email, subject: 'Added Total Judged Coins' )
  end

  def amazon_purshase_card(user, card, coins)
    @user = user
    @card = card
    @coins = coins
    mail(to: @user.email, subject: 'Amazon Card Purshase' )
  end
end
