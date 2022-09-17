class Story < ApplicationRecord
  belongs_to :user
  has_one_attached :attachment

  validate :attachment_presence

  private

  def attachment_presence
    errors.add(:attachment, 'is missing') unless attachment.attached?
  end

  after_create_commit lambda {
    StoriesCleanupJob.set(wait: 1.minute).perform_later(id)
  }
end
