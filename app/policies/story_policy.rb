class StoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.present?
  end

  def update?
    return true if user.present? && user == story.user
  end

  def destroy?
    return true if user.present? && user == story.user
  end

  private

  def story
    record
  end
end
