require "test_helper"

class CoinPricesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get coin_prices_index_url
    assert_response :success
  end
end
