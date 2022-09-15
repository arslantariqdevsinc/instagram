class User < ApplicationRecord
  attr_writer :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, format: { with: /^[a-zA-Z0-9_.]*$/, multiline: true }

  validate :validate_username

  has_one_attached :avatar
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy,
                                  inverse_of: :follower
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy,
                                   inverse_of: :followed

  has_many :pending_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy,
                                   inverse_of: :follower
  has_many :pending_requests, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy,
                              inverse_of: :followed

  has_many :following, -> { where('status = ?', 1) }, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :pending_follows, -> { where('status = ?', 0) }, through: :pending_relationships, source: :followed
  has_many :follow_requests, -> { where('status = ?', 0) }, through: :pending_requests, source: :follower

  has_many :stories, dependent: :destroy

  def to_param
    username
  end

  def login
    @login || username || email
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

  def follow(other_user)
    status = other_user.is_private? ? :pending : :accepted
    active_relationships.create(followed_id: other_user.id, status: status)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def requested?(other_user)
    pending_follows.include?(other_user)
  end

  def suggestions
    ids = following_ids
    ids << id
    User.where('id NOT IN (?)', ids).first(5)
  end

  def generate_feed
    # @feed_posts = Post.where(user_id: following_ids)  #{Slow}
    following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    Post.where("user_id IN (#{following_ids})", user_id: id)
  end
end
