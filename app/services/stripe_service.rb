require 'json'
require 'sinatra'
require 'stripe'
require 'uri'

class StripeService
  def initialize()
    Stripe.api_key = Rails.configuration.stripe[:secret_key]
    protect_from_forgery with: :null_session
  end

  def self.webhook(request,user)
    payload = request.body.read
    sig_header = request.headers['HTTP_STRIPE_SIGNATURE']
    endpoint_secret =  Rails.configuration.stripe[:webhook_secret]
      
    if sig_header.nil?
      puts "Stripe signature header not present"
      return
    end
  
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      puts "JSON parsing error: #{e.message}"
      return
    rescue Stripe::SignatureVerificationError => e
      puts "Stripe signature verification failed: #{e.message}"
      return
    end
  
    # Handle the event
    case event.type
    when 'checkout.session.completed'
      handle_checkout_session_completed(event)
  
    when 'payment_intent.succeeded'
      handle_payment_intent_succeeded(event)
    # Add more event handlers as needed
    else
      puts "Unhandled event type: #{event.type}"
    end
    return :ok
  end
  

  def self.find_or_create_customer(user)
    begin
      if user.stripe_id.present?
        stripe_customer = Stripe::Customer.retrieve(user.stripe_id)
      else
        stripe_customer = Stripe::Customer.create({
                                                    name: user.username,
                                                    email: user.email,
                                                    phone: user.phone,
                                                  })
        user.update(stripe_id: stripe_customer.id)
      end
      stripe_customer
    rescue Stripe::StripeError => e
      e.message
    end
  end

  def self.create_card_token(params)
    begin
      Stripe::Token.create({
                             card: {
                               number: params[:number].to_s,
                               exp_month: params[:exp_month],
                               exp_year: params[:exp_year],
                               cvc: params[:cvc],
                               name: params[:first_name] + ' ' + params["last_name"]
                             },
                           })
    rescue Stripe::CardError => e
      e.message
    end
  end

  def self.create_stripe_customer_card(user, params)
    begin
      customer = find_or_create_customer(user)
      # token = create_card_token(params)
      # return token if token.class == String
      card = Stripe::Customer.create_source(
        customer.id,
        { source: params[:token],},
      )
      if card.present?
        user.user_cards.create!(name: params[:first_name] + ' ' + params[:last_name],
                                country: params[:country],
                                expiry_month: card.exp_month,
                                expiry_year: card.exp_year,
                                card_id: card.id,
                                brand: card.brand,
                                last_four: card.last4.to_i,
                                number: card.last4.to_i
        )
      end
      card
    rescue Stripe::CardError => e
      e.message
    end
  end

  def self.delete_card(user, params)
    begin
      card = Stripe::Customer.delete_source(
        user.stripe_id,
        params[:card_id]
      )
      if card.present?
        UserCard.find_by(card_id: params[:card_id]).destroy
      end
      card
    rescue Stripe::CardError => e
      e.message
    end
  end

  def self.find_user_cards(user)
    begin
      cards = Stripe::Customer.list_sources(
        user.stripe_id,
        { object: 'card' },
      )
      cards
    rescue Stripe::CardError => e
      e.message
    end
  end

  def self.create_stripe_charge(user, params)
    begin
      charge = Stripe::Charge.create({
                                       amount: params[:amount_to_be_paid].to_i * 100,
                                       currency: 'usd',
                                       source: params[:card_id],
                                       customer: user.stripe_id,
                                       description: "Amount $#{params[:amount_to_be_paid]} charged for coins",
                                     })
      if charge.present?
        if params[:amount_to_be_paid].to_i == 1
          coins = 10000
        elsif params[:amount_to_be_paid].to_i == 3
          coins = 30000
        elsif params[:amount_to_be_paid].to_i == 5
          coins = 50000
        elsif params[:amount_to_be_paid].to_i == 10
          coins = 100000
        elsif params[:coins].present?
          coins = params[:coins]
        end
        # coins = (params[:amount_to_be_paid].to_i * 100)/0.00083
        purshased_coins = coins
        user_coin = user.coins
        coins += user_coin
        user.update(coins: coins)
        Transaction.create!({
                              charge_id: charge.id,
                              customer_id: charge.customer,
                              amount: charge.amount * 0.01,
                              balance_transaction_id: charge.balance_transaction,
                              card_number: charge.payment_method,
                              brand: charge.source.brand,
                              currency: charge.currency,
                              user_id: user.id,
                              username: user.username,
                              coins: purshased_coins,
                            })
      end
      charge
    rescue
    end
  end

  def self.create_payment_intent(amount, customer)
    Stripe::PaymentIntent.create({
      amount: amount,
      customer: customer,
      currency: 'usd'
    })
  end

  def self.retrieve_payment_intent(intent)
    Stripe::PaymentIntent.retrieve(
      intent,
    )
  end

  def self.handle_checkout_session_completed(event)
    session = event.data.object
    puts "handle_checkout_session_completed ===== #{session}"
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    puts "Amount  ===== #{(session.amount_subtotal.to_i)/100.to_i}"
    amount_paid = (session.amount_subtotal.to_i)/100
    puts "Customer email===== #{session.customer_email}"
    user = User.find_by(email: session.customer_email)

    puts "Customer ===== #{session.customer}"
    puts "id ===== #{session.id}"

    puts "user by email ==== #{user}"  
    
    if amount_paid == 1
      coins = 10000
    elsif amount_paid == 3
      coins = 30000
    elsif amount_paid == 5
      coins = 50000
    elsif amount_paid == 10
      coins = 100000
    else
      url_string = session.success_url
      uri = URI.parse(url_string)
      query_params = URI.decode_www_form(uri.query).to_h
      url_amount = query_params['amount']
      url_coins = query_params['coins']
      coins = url_coins.to_i
    end

    purshased_coins = coins
    puts "Purhased coins  == #{coins}"
    if user.coins
    user_coin = user.coins 
    else
    user_coin = 0
    end
    puts "user_coin   == #{user_coin}"
    coins = coins + user_coin
    puts "updated coins    == #{coins}"
    user.update(coins: coins)
    charge = Transaction.create!({
                          amount: amount_paid,
                          balance_transaction_id: session.id,
                          user_id: user.id,
                          coins: purshased_coins,
                          username: user.username,
                          customer_id: session.customer
                        })
  charge
  end

  def self.handle_payment_intent_succeeded(event)
    payment_intent = event.data.object
    # Retrieve relevant data from the payment_intent object and perform actions
  end


end