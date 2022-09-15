class Story < ApplicationRecord
  belongs_to :user
  has_one_attached :video

  validates :body, presence: true
  validate :video_presence

  def video_presence
    errors.add(:images, 'are missing') unless images.attached?
  end
end
