class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :post
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy, inverse_of: :parent
  belongs_to :user

  has_many :likes, as: :likeable, dependent: :destroy

  validates :body, presence: true

  after_create_commit lambda {
    broadcast_append_to [post, :comments], target: "#{dom_id(post)}_comments"
  }

  after_destroy_commit do
    broadcast_remove_to self
  end

  after_update_commit do
    broadcast_replace_to self
  end
end
