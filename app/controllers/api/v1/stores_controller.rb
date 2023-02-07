class Api::V1::StoresController < Api::V1::ApiController
  before_action :authorize_request
  before_action :check_item, only: :create

  def index
    @store = UserStore.where(user_id: @current_user.id)
    if @store.present?
      render json: { items_bought: @store.count, store: @store, tournament: TournamentBanner.find_by(enable: true).title }, status: :ok
    else
      if TournamentBanner.find_by(enable: true).present?
        render json: { message: "#{TournamentBanner.find_by(enable: true).title}" }, status: :not_found
      else
        render json: { message: [] }, status: :not_found
      end
    end

  end

  def create
    user_coin = @current_user.coins
    coins = user_coin - params[:amount].to_i
    if coins < 0
      render json: { message: "Insufficient coins" }, status: :unauthorized
    else
      @store = UserStore.new(user_id: @current_user.id,
                             name: params[:name],
                             amount: params[:amount].to_i,
                             status: true)

      if @store.save
        @current_user.update(coins: coins)
        # Notification.create(title: "In App Purchase", body: "#{@store.name} have been bought successfully",
        #                     user_id: @current_user.id,
        #                     notification_type: 'in_app_purchase')
        render json: { store: @store,
                       coins: coins,
                       message: "#{params[:amount].to_i} have been deducted from #{@current_user.username}'s account" }, status: :ok
      else
        render_error_messages(@store)
      end
    end

  end

  private

  def check_item
    @store = UserStore.where(user_id: @current_user.id, name: params[:name])
    if @store.present?
      return render json: { message: 'Item Exists' }
    else

    end
  end

end