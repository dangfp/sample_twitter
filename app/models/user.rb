class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :tweets

  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :followings, through: :following_relationships, source: 'following'

  has_many :follower_relationships, class_name: 'Relationship', foreign_key: 'followed_id'
  has_many :followers, through: :follower_relationships, source: 'follower'
  
  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true, length: {minimum: 6}
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    format: { with: VALID_EMAIL_REGEX, 
                              message: "format is invalid." }
  validates :password, presence: true, length: {minimum: 6}, on: [:create]

  before_save { self.email = email.downcase }

  def who_to_follow
    not_to_be_followed_users = []
    not_to_be_followed_users = self.followings.ids
    not_to_be_followed_users << self.id

    User.where.not(id: not_to_be_followed_users)
  end
end