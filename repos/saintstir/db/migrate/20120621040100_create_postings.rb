class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.text :content
      t.string :status
      t.integer :votes
      t.integer :user_id
      t.integer :saint_id
      t.string :posting_type
      t.timestamps
    end

    add_index :postings, :user_id
    add_index :postings, :saint_id
    add_index :postings, :status
    add_index :postings, :votes

  end
end
