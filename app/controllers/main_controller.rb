class MainController < ApplicationController
  before_action :turbo_frame_request_variant
  def search
    if params[:query].present?
      @query = User.ransack(username_cont: params[:query])
      @users = @query.result.limit(5)
    else
      @users = User.none
    end
  end

  private

  def force_json
    request.format = :json
  end

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end
end
