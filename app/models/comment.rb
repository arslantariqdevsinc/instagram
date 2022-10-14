class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :post
  belongs_to :parent, class_name: 'Comment', optional: true
  belongs_to :user
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy, inverse_of: :parent
  has_many :likes, as: :likeable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 220 }
end
