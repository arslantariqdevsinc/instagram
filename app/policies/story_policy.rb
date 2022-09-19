class StoryPolicy < ApplicationPolicy
  def destroy?
    owner?
  end
end
