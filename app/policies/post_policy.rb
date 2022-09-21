class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.present?
        scope.all
      else
        scope.none
      end
    end
  end

  def new?
    user.present?
  end

  def show?
    post.user == user || post.user.public? || user.following?(post.user)
  end

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

  def post
    record
  end
end
