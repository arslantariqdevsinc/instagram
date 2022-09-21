class Story < ApplicationRecord
  belongs_to :user
  has_one_attached :attachment

  validates :body, presence: true
  validates :attachment, attached: true

  after_create_commit lambda {
    StoriesCleanupJob.set(wait: 24.hours).perform_later(id)
  }
end
