# frozen_string_literal: true
class Api::V1::PaymentsController < Api::V1::ApiController
  before_action :authorize_request
  require "stripe"


  def create_checkout_session
    Stripe.api_key =  Rails.configuration.stripe[:secret_key]
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [
          {
              price_data: {
                  currency: 'usd', 
                  product_data: {
                      name: params[:product_name],
                  },
                  unit_amount: params[:amount]*100, 
              },
              quantity: 1,
          },
      ],
      mode: 'payment',
      customer_email: @current_user.email,
      success_url: 'http://localhost:3001/BuyCoin?amount=10&coins=12000',
      cancel_url: 'http://localhost:3001/home'
    )

    render json: { sessionId: session.id, session_url: session.url }
  end

  def add_user_to_stripe
    response = StripeService.find_or_create_customer(@current_user)
    if response.present?
      render json: { user: response }, status: :ok
    else
      render json: { message: "User not added" }, status: :not_found
    end
  end

  def add_a_card
    if @current_user.user_cards.find_by(user_id: @current_user.id).present?
      render json: { message: "Card already exits" }, status: :bad_request
    else
      response = StripeService.create_stripe_customer_card(@current_user, params)
      return render json: { card:[] ,message: response}, status: :unprocessable_entity if response.class == String
      if response.present?
        render json: { card: response }, status: :ok
      else
        render json: { card: [], message: "Card not added" }, status: :not_found
      end
    end
  end

  def edit_a_card
    response = StripeService.delete_card(@current_user, params)
    if response.present?
      render json: { card: response }, status: :ok
    else
      render json: { card: [], message: "Cannot Edit " }, status: :not_found
    end
  end

  def fetch_all_card
    if @current_user.user_cards.present?
    else
      render json: { card: [], message: "No cards found " }, status: :not_found
    end
  end

  def delete_a_card
    response = StripeService.delete_card(@current_user, params)
    if response.present?
      render json: { card: response }, status: :ok
    else
      render json: { card: [], message: "No Card found" }, status: :not_found
    end

  end

  def charge_a_customer
    if params[:platform] == 'ios'
      @history = Transaction.create(amount: params[:amount_to_be_paid],
                                    brand: 'In App Purchase',
                                    coins: params[:coins].to_i,
                                    username: @current_user.username,
                                    user_id: @current_user.id
      )
      coins = @current_user.coins + params[:coins].split(',').join.to_i
      @current_user.update(coins: coins)
      return render json: { error: @history.errors.full_messages }, status: :unprocessable_entity unless @history.save

      render json: { history: @history, coins: @current_user.coins }, status: :ok
    else
      return render json: { message: 'Invalid Card' }, status: :unauthorized unless @current_user.stripe_id.present?
      if response.present?
        response = StripeService.create_stripe_charge(@current_user, params)
        # Notification.create(title: "In App Purchase",body: "You have bought coins successfully of amount #{params[:amount_to_be_paid]}",
        #                     user_id: @current_user.id,
        #                     notification_type: 'coin_buy')
        render json: { charge: response, coins: @current_user.coins }, status: :ok
      else
        render json: { charge: [], message: "Cannot be charged" }, status: :not_found
      end
    end
  end

  def stripe_checkout_coins
        if params[:amount_paid].to_i == 10
          coins = 12000
        elsif params[:amount_paid].to_i == 25
          coins = 20000
        elsif params[:amount_paid].to_i == 50
          coins = 60000
        elsif params[:amount_paid].to_i == 75
          coins = 90000
        elsif params[:amount_paid].to_i == 100
          coins = 120000
        end
        # coins = (params[:amount_to_be_paid].to_i * 100)/0.00083
        user_coin = @current_user.coins
        coins += user_coin
        @current_user.update(coins: coins)
        charge = Transaction.create!({
                              amount: params[:amount_paid],
                              user_id: @current_user.id,
                              coins: params[:coins],
                              username: @current_user.username
                            })
      charge
      render json: { charge: charge, coins: @current_user.coins }, status: :ok
  end

  def show_transactions_history
    if params[:platform] == 'ios'
      @history = Transaction.where(user_id: @current_user.id, customer_id: nil)
    else
      @history = Transaction.where(user_id: @current_user.id)
    end
    if @history.present?
      render json: { transaction_count: @history.count, total_history: @history }, status: :ok
    else
      render json: { history: [] }, status: :ok
    end
  end

  def payment_intent
    begin
      intent = StripeService.create_payment_intent((params[:amount].to_i)*100, @current_user.stripe_id)
      render json: { payment_intent: intent }
    rescue => e
      return render json: { error: e.message }
    end
  end

  def apple_pay
    payment_intent = StripeService.retrieve_payment_intent(params[:payment_intent])
    if payment_intent.status == "succeeded"
      if params[:amount_to_be_paid].to_i == 10
        coins = 12000
      elsif params[:amount_to_be_paid].to_i == 25
        coins = 20000
      elsif params[:amount_to_be_paid].to_i == 50
        coins = 60000
      elsif params[:amount_to_be_paid].to_i == 75
        coins = 90000
      elsif params[:amount_to_be_paid].to_i == 100
        coins = 120000
      end
      # coins = (params[:amount_to_be_paid].to_i * 100)/0.00083
      user_coin = @current_user.coins
      coins += user_coin
      @current_user.update(coins: coins)
      Transaction.create!({
                            charge_id: payment_intent.id,
                            customer_id: payment_intent.customer,
                            amount: payment_intent.amount * 0.01,
                            card_number: 'apple_pay',
                            brand: 'apple_pay',
                            currency: payment_intent.currency,
                            user_id: @current_user.id,
                            username: @current_user.username
                          })
      render json: { intent: payment_intent, coins: @current_user.coins }
    else
      render json: { message: "Your transaction has not been succeeded"}
    end
  end
end

