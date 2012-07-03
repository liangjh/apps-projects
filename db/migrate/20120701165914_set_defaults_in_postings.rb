class SetDefaultsInPostings < ActiveRecord::Migration
  def up
    remove_column :postings, :votes
    add_column :postings, :votes, :integer, :default => 0
  end

  def down
    #// no need to down migrate this, since we're just changing attrib of a column
  end
end
