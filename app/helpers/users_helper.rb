module UsersHelper
  def user_me?(user)
    user == current_user
  end

  def public?(user)
    !user.is_private
  end
end
