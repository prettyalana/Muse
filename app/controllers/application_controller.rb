class ApplicationController < ActionController::Base
  skip_forgery_protection
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:image, :bio, :name, :address, :location, :account_type])
    devise_parameter_sanitizer.permit(:update, keys: [:image, :bio, :name, :address, :location, :account_type])
  end
end
