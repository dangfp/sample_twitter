class AddRetweetsCountToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :retweets_count, :integer, default: 0
  end
end
