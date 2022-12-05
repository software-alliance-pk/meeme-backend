Rails.configuration.stripe = {
  :secret_key => "sk_test_51M9ScdLiBz4Ob5xR2eDBHrtxsHi2Z3TKMNpFaN9VrElVSPlCuf6L7ZxydQduEBj3QtW8L9KtATesN5CIOuDAwBgu00i1W7kn3e",
  :publishable_key => "pk_test_51M9ScdLiBz4Ob5xR3OOO0blU73Nw7lURgo2tvHO1BsjyTRsddRUxDIogJrXH44HmcZQnLajETBf80rufqs4Vbp4b00E368Nhn5"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]