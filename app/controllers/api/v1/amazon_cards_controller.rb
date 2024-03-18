class Api::V1::AmazonCardsController < Api::V1::ApiController
    before_action :authorize_request
  
    def index
      @amazon_cards = AmazonCard.all
      render json: @amazon_cards
    end
  
    def purchase_card
      card_id = params[:card_id]
      card = AmazonCard.find_by(id: card_id)
      if card.nil?
        render json: { message: "Card not found" }, status: :not_found
        return
      end
  
      current_user = @current_user 
      if current_user.coins < card.coin_price
        render json: { message: "Insufficient coins" }, status: :unprocessable_entity
        return
      end
      coin = card.coin_price
      UserMailer.amazon_purshase_card(@current_user, card.gift_card_number, card.coin_price).deliver_now

      current_user.update(coins: current_user.coins - card.coin_price)
      card.destroy
  
      render json: { message: "Card purchased successfully" , coins_deducted: coin , user_coins: @current_user.coins}, status: :ok
    end
  end
  