class CommentPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def edit?
    owner?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end
end
