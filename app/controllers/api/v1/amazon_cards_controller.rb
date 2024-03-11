class Api::V1::AmazonCardsController < Api::V1::ApiController
    before_action :authorize_request

    def index
        @amazon_cards = AmazonCard.all
        render json: @amazon_cards
      end
  end