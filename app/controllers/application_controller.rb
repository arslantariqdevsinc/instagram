class ApplicationController < ActionController::Base
  protect_from_forgery

  ADDED_ATTR = %i[username email password password_confirmation remember_me]

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: ADDED_ATTR
    devise_parameter_sanitizer.permit :sign_in, keys: %i[login password]
    devise_parameter_sanitizer.permit :account_update,
                                      keys: [ADDED_ATTR, :avatar, :fullname, :bio, :website, :is_private]
  end
end
