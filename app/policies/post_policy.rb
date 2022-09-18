class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.present?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  private

  def post
    record
  end
end
