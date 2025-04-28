module Api
  module V1
    class CoinPricesController < ApplicationController
      skip_before_action :authenticate_admin_user!
      def index
        coin_prices = CoinPrice.all
        render json: coin_prices
      end
    end
  end
end
