class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 2200 }
  validates :images, attached: true, content_type: ['image/jpeg', 'image/png'], limit: { min: 1, max: 10 }
end
