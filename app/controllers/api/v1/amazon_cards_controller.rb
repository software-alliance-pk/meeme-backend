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

      # Send a Notification for Admin 
      Notification.create(title:"Gift Card #{card.gift_card_number} Purshased by #{@current_user.username}",
      body: card.gift_card_number,
      user_id: @current_user.id,
      notification_type: 'admin_message',
      sender_id: @current_user.id,
      sender_image: @current_user.profile_image.present? ? @current_user.profile_image.blob.url : '',
      redirection_type:'amazon_card'
      )

      current_user.update(coins: current_user.coins - card.coin_price)
      card.destroy
  
      render json: { message: "Card purchased successfully" , coins_deducted: coin , user_coins: @current_user.coins}, status: :ok
    end
  end
  