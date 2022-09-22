class User < ApplicationRecord
  attr_writer :login

  scope :with_story, -> { where('EXISTS(SELECT 1 FROM stories WHERE user_id = users.id)') }

  has_one_attached :avatar
  has_many :posts, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy,
                                  inverse_of: :follower
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy,
                                   inverse_of: :followed
  has_many :following, -> { where('status = ?', 1) }, through: :active_relationships, source: :followed
  has_many :followers, -> { where('status = ?', 1) }, through: :passive_relationships, source: :follower
  has_many :pending_follows, -> { where('status = ?', 0) }, through: :active_relationships, source: :followed
  has_many :follow_requests, -> { where('status = ?', 0) }, through: :passive_relationships, source: :follower

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :avatar, content_type: 'image/png',
                     dimension: { width: 200, height: 200 }
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, format: { with: /^[a-zA-Z0-9_.]*$/, multiline: true }
  validate :validate_username

  def to_param
    username
  end

  def login
    @login || username || email
  end

  def private?
    is_private?
  end

  def public?
    !is_private?
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
    elsif conditions[:username].nil?
      where(conditions).first
    else
      where(username: conditions[:username]).first
    end
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def validate_username
    errors.add(:username, :invalid) if User.where(email: username).exists?
  end

  def following?(user)
    following.include?(user)
  end

  def requested?(user)
    pending_follows.include?(user)
  end

  def suggestions
    ids = following_ids
    ids << id
    User.where('id NOT IN (?)', ids).first(5)
  end

  def generate_posts
    following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  def generate_stories
    users_with_stories = following.with_story
    users_with_stories = Array(users_with_stories)
    stories.any? ? users_with_stories << self : users_with_stories
  end
end
