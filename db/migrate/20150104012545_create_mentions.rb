class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.boolean :read, default: false
      t.integer :user_id, :tweet_id

      t.timestamps
    end
  end
end
