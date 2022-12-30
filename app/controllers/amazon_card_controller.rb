class AmazonCardController < ApplicationController

    def create_amazon_card
        case route_to params
        when :Create
            @amazon_card = AmazonCard.new(gift_card_params)
            if @amazon_card.save
                redirect_to gift_rewards_path
            end
        else
            @gift_card = GiftReward.new(card_params)
            if @gift_card.save
                redirect_to gift_rewards_path
            end
        end
    end

    def update_card
        @card = AmazonCard.find(params[:id])
        @card.update(amount: params[:amount], gift_card_number: params[:gift_card_number], coin_price: params[:coin_price])
        redirect_to gift_rewards_path
    end

    def card_destroy
        @card = AmazonCard.find(params[:id])
        if @card.destroy
          redirect_to gift_rewards_path
        end
    end

    private

    def gift_card_params
        params.permit(:amount, :gift_card_number, :coin_price)
    end

    def card_params
        params.permit(:rank, :card_number, :amount)
    end

    def route_to params
        if params[:route_to].present?
            params[:route_to].keys.first.to_sym
        end
    end
end