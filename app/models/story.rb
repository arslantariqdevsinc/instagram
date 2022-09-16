class Story < ApplicationRecord
  belongs_to :user
  has_one_attached :attachment

  validate :attachment_presence

  private

  def attachment_presence
    errors.add(:attachment, 'is missing') unless attachment.attached?
  end
end
