class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :username, :email, :fullname, :created_at, :avatar

  # def followers
  #   object.followers.map do |follower|
  #     {name: follower.username}
  #   end
  # end

  def avatar
    if object.avatar.present?
      url_for(object.avatar)
    else
      nil
    end
  end
end
