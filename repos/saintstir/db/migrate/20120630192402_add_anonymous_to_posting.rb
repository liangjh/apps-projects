class AddAnonymousToPosting < ActiveRecord::Migration
  def up
    add_column :postings, :anonymous, :boolean, :default => false
  end

  def down
    remove_column :postings, :anonymous
  end
end
