class Tweet < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_one :mention
  has_many :replies, foreign_key: 'parent_id', class_name: 'Tweet'

  belongs_to :origin, foreign_key: 'origin_id', class_name: 'Tweet', counter_cache: :retweets_count
  has_many :tweets, foreign_key: 'origin_id', class_name: 'Tweet'

  validates :body, presence: true, length: {maximum: 140}

  after_save :extract_mention

  def extract_mention
    mentioned_username = self.body.scan(/@(\w+)/)

    mentioned_username.each do |username|
      user = User.find_by(username: username[0])
      Mention.create(tweet_id: self.id, user_id: user.id) if user
    end
  end

  def is_retweet?
    origin.present?
  end
end