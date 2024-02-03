class CreateUserPostingLikes < ActiveRecord::Migration
  def change
    create_table :user_posting_likes do |t|
      t.integer :user_id
      t.integer :posting_id

      t.timestamps
    end

    add_index :user_posting_likes, :user_id
    add_index :user_posting_likes, :posting_id
  end
end
