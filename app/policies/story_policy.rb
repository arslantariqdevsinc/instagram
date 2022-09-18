class StoryPolicy < ApplicationPolicy
  def destroy?
    owner?
  end

  private

  def story
    record
  end
end
