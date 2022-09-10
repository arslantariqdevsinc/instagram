class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :comments, dependent: :destroy

  validates :body, presence: true, length: { maximum: 2200 }
  validate :image_presence, :image_type

  private

  def image_presence
    errors.add(:images, 'are missing') unless images.attached?
  end

  def image_type
    images.each do |image|
      unless image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:images,
                   'File type not supported. Only Jpeg, PNG are supported.')
      end
    end
  end
end
