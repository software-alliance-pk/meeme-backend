class GiftCardRequestsController < ApplicationController
    def index
        @gift_card_requests = GiftCardRequest.all 
      end
  end
  