class UserPolicy < ApplicationPolicy
  def show?
    true
  end

  def following?
    other_user.public? || other_user.private? && user.following?(other_user)
  end

  def followers?
    other_user.public? || other_user.private? && user.following?(other_user)
  end

  def other_user
    record
  end
end
