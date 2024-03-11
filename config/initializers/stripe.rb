# Rails.configuration.stripe = {
#   :secret_key => "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",
#   :publishable_key => "pk_live_51LiJD6GTUIZsigd59dvkHtC2tgQMYr61Hu7wzCvEGFAUoNprt40lGGk9hoK3d6PaW7DJGiQuhgl0qAKgfQeNZTcB00Q5dyZtMK"
# }
Rails.configuration.stripe = {
  :secret_key => ENV['STRIPE_SECRET_KEY'],
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]