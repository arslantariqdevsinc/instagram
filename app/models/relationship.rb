class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  enum status: { pending: 0, accepted: 1 }

  # validates :status, inclusion: { in: %w[pending accepted] }

  before_validation :set_status

  def set_status
    self.status ||= followed.private? ? :pending : :accepted
  end
end
