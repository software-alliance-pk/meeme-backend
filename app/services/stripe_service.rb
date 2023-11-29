class StripeService
  def initialize()
    Stripe.api_key = Rails.configuration.stripe[:secret_key]

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
      token = create_card_token(params)
      return token if token.class == String
      card = Stripe::Customer.create_source(
        customer.id,
        { source: token.id,
        },
      )
      if card.present?
        user.user_cards.create!(name: params[:first_name] + ' ' + params[:last_name],
                                country: params[:country],
                                expiry_month: params[:exp_month],
                                expiry_year: params[:exp_year],
                                cvc: params[:cvc],
                                country: params[:country],
                                card_id: card.id,
                                brand: card.brand,
                                last_four: card.last4.to_i,
                                number: params[:number].to_i
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
                              username: user.username
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

end