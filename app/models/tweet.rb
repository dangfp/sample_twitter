class Tweet < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_one :mention

  validates :body, presence: true, length: {maximum: 140}

  after_save :extract_mention

  def extract_mention
    mentioned_username = self.body.scan(/@(\w+)/)

    mentioned_username.each do |username|
      user = User.find_by(username: username[0])
      Mention.create(tweet_id: self.id, user_id: user.id) if user
    end
  end
end