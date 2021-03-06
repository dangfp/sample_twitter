class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :tweets
  has_many :mentions

  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :followings, through: :following_relationships, source: 'following'

  has_many :follower_relationships, class_name: 'Relationship', foreign_key: 'followed_id'
  has_many :followers, through: :follower_relationships, source: 'follower'
  
  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true, length: {minimum: 3}
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    format: { with: VALID_EMAIL_REGEX, 
                              message: "format is invalid." }
  validates :password, presence: true, length: {minimum: 6}, on: [:create]

  before_save { self.email = email.downcase }

  def who_to_follow
    User.where.not(id: not_to_be_followed_user_ids)
  end

  def not_to_be_followed_user_ids
    not_to_be_followed_user_ids = self.followings.ids
    not_to_be_followed_user_ids << self.id
  end

  def all_tweets_for_display
    all_tweets = []

    all_tweets = self.tweets
    self.followings.each do |following|
      all_tweets += following.tweets
    end
    all_tweets
  end

  def not_read_mentions
    mentions.where(read: false)
  end

  def not_read_mentions_count
    not_read_mentions.count
  end

  def mark_mentions_to_read
    not_read_mentions.each do |mention|
      mention.update(read: true)
    end
  end
end