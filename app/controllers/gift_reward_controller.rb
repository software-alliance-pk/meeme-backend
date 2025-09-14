class GiftRewardController < ApplicationController

    def add_gift_card
        @gift_card = GiftReward.new(card_params)
        if @gift_card.save
            redirect_to gift_rewards_path
        end
    end

    private

    def card_params
        params.permit(:rank, :card_number, :amount)
    end
end