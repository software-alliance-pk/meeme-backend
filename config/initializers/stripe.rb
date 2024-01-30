# Rails.configuration.stripe = {
#   :secret_key => "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",
#   :publishable_key => "pk_live_51LiJD6GTUIZsigd59dvkHtC2tgQMYr61Hu7wzCvEGFAUoNprt40lGGk9hoK3d6PaW7DJGiQuhgl0qAKgfQeNZTcB00Q5dyZtMK"
# }
Rails.configuration.stripe = {
  :secret_key => "sk_test_51LiJD6GTUIZsigd5yRW04VodgrEfknBffr0YThrlAYkEIVGkHghNhnt5qT41dh32abiGEbgVskBLlTzqO4M4RpwZ00Joba1HUl",
  :publishable_key => "pk_test_51LiJD6GTUIZsigd57m5jhX6S8DY0CSJuHudL8juFtK1qEbVS9NiHkOvTxeiIQUuWvbQWLtaCqaDmN9Mpa0efDnP700jgE0oVnJ"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]