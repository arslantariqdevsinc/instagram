class MainController < ApplicationController
  before_action :authenticate_user!
  before_action :turbo_frame_request_variant

  def search
    @users = if params[:query].present?
               User.ransack(username_cont: params[:query]).result.limit(5)
             else
               User.none
             end
  end

  private

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end
end
