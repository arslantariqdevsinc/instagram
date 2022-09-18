class ApplicationController < ActionController::Base
  include Pundit::Authorization
  protect_from_forgery

  ADDED_ATTR = %i[username email password password_confirmation remember_me].freeze

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: ADDED_ATTR
    devise_parameter_sanitizer.permit :sign_in, keys: %i[login password]
    devise_parameter_sanitizer.permit :account_update,
                                      keys: [ADDED_ATTR, :avatar, :fullname, :bio, :website, :is_private]
  end

  private

  def user_not_authorized
    flash[:notice] = 'You are not authorized to perform this action.'
    redirect_to(request.referer || authenticated_root_path)
  end
end
