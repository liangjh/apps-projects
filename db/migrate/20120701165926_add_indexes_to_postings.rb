class AddIndexesToPostings < ActiveRecord::Migration
  def change
    #// missed the votes index, since we may need to sort by this column
    add_index :postings, :votes
  end
end
