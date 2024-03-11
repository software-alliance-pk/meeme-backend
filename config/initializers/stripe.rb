Rails.configuration.stripe = {
  :secret_key => ENV['STRIPE_SECRET_KEY'],
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]