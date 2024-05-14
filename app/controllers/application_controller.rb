class ApplicationController < ActionController::Base
  # before_action :authenticate_admin_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user, if: :admin_user_signed_in?
  skip_before_action :verify_authenticity_token
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password,
                                                       :password_confirmation,
                                                       :full_name,
                                                       :admin_user_name])
  end

  def set_current_user
    Current.admin_user = current_admin_user
  end
end
