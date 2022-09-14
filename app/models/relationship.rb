class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # validates :status, inclusion: { in: %w[pending accepted] }

  enum status: { pending: 0, accepted: 1 }
end
