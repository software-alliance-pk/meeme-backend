class ApplicationController < ActionController::Base
  # before_action :authenticate_admin_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password,
                                                       :password_confirmation,
                                                       :full_name,
                                                       :admin_user_name])
  end
end