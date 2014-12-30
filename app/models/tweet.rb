class Tweet < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'

  validates :body, presence: true, length: {maximum: 140}
end