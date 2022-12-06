# frozen_string_literal: true
class Api::V1::PaymentsController < Api::V1::ApiController
  before_action :authorize_request
  require "stripe"

  def add_user_to_stripe
    response = StripeService.find_or_create_customer(@current_user)
    if response.present?
      render json: { user: response }, status: :ok
    else
      render json: { message: "User not added" }, status: :not_found
    end
  end

  def add_a_card
    if @current_user.user_cards.find_by(number: params[:number].to_i).present?
      render json: { message: "Card already exits" }, status: :bad_request
    else
      response = StripeService.create_stripe_customer_card(@current_user, params)
      if response.present?
        render json: { card: response }, status: :ok
      else
        render json: { card: [], message: "Card not added" }, status: :not_found
      end
    end
  end

  def edit_a_card
    response = StripeService.delete_card(@current_user, params)
    if response.present?
      render json: { card: response }, status: :ok
    else
      render json: { card: [], message: "Cannot Edit " }, status: :not_found
    end
  end

  def fetch_all_card
    if @current_user.user_cards.present?
    else
      render json: { card: [], message: "No cards found " }, status: :not_found
    end
  end

  def delete_a_card
    response = StripeService.delete_card(@current_user, params)
    if response.present?
      render json: { card: response }, status: :ok
    else
      render json: { card: [], message: "No Card found" }, status: :not_found
    end

  end

  def charge_a_customer
    return render json: {message: 'Invalid Card'}, status: :unauthorized unless @current_user.stripe_id.present?
    if response.present?
      response = StripeService.create_stripe_charge(@current_user, params)
      render json: { charge: response }, status: :ok
    else
      render json: { charge: [], message: "Cannot be charged" }, status: :not_found
    end
  end

  def show_transactions_history
    @history = Transaction.where(user_id: @current_user.id)
    if @history.present?
      render json: { transaction_count: @history.count, total_history: @history }, status: :ok
    else
      render json: { history: [] }, status: :not_found
    end
  end
end

