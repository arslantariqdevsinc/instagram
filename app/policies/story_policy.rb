class StoryPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    owner?
  end
end
