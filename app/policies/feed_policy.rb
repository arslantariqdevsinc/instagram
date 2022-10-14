class FeedPolicy < ApplicationPolicy
  def show?
    user.present?
  end
end
