class RelationshipPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    initiator?
  end

  def destroy?
    initiator?
  end

  private

  def initiator?
    relationship.follower == user || relationship.followed == user if user.present?
  end

  def relationship
    record
  end
end
