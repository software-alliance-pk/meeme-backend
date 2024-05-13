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

      # Create a new record in the GiftCardRequest table
      gift_card_request = GiftCardRequest.create(
        user_id: current_user.id,
        user_email: current_user.email,
        status: 'pending',
        amount: card.amount,
        coins: card.coin_price
      )
      # Send a Notification for Admin 
      Notification.create(title:" #{@current_user.username} Requested to Purchase £#{card.amount} Amazon Gift Card ",
      body: card.gift_card_number,
      user_id: @current_user.id,
      notification_type: 'admin_message',
      sender_id: @current_user.id,
      sender_image: @current_user.profile_image.present? ? @current_user.profile_image.blob.url : '',
      redirection_type:'amazon_card',
      request_id: gift_card_request.id,
      )
      # coin = card.coin_price
      # UserMailer.amazon_purshase_card(@current_user, card.gift_card_number, card.coin_price).deliver_now
      
      # current_user.update(coins: current_user.coins - card.coin_price)
      # card.destroy
  
      render json: { message: "Amazon Gift will be sent to you in 24/48 hours"}, status: :ok
    end
  end
  