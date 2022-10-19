class Story < ApplicationRecord
  belongs_to :user
  has_one_attached :attachment

  validates :body, presence: true, length: { maximum: 2200 }
  validates :attachment, attached: true

  after_create_commit -> {
    StoriesCleanupJob.set(wait: 24.hours).perform_later(id)
  }
end
