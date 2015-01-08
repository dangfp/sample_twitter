class AddOriginIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :origin_id, :integer
  end
end
