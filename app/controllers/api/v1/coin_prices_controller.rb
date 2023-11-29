module Api
    module V1
      class CoinPricesController < ApplicationController
        def index
          coin_prices = CoinPrice.all
          render json: coin_prices
        end
      end
    end
  end
  
