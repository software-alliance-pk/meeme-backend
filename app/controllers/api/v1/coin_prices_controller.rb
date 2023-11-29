module Api
<<<<<<< HEAD
  module V1
    class CoinPricesController < ApplicationController
      def index
        coin_prices = CoinPrice.all
        render json: coin_prices
      end
    end
  end
end
=======
    module V1
      class CoinPricesController < ApplicationController
        def index
          coin_prices = CoinPrice.all
          render json: coin_prices
        end
      end
    end
  end
  
>>>>>>> 71e3ec5de6d88724251a4206f3626a337424ddd5
