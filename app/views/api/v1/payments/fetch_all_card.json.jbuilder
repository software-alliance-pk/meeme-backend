json.user_cards_count @current_user.user_cards.count
json.user_cards @current_user.user_cards.each do|card|
  json.name card.name
  json.country card.country
  json.cvc card.cvc
  json.card_id card.card_id
  json.exp_month card.expiry_month
  json.exp_year card.expiry_year
  json.card_number card.number
  json.card_created_at card.created_at
  json.brand card.brand
  json.last4 card.last_four
end