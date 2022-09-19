class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end
end
