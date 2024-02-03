class AddIndexesToApiUser < ActiveRecord::Migration

  def up
    add_index :api_users, :key
  end

  def down
    remove_index :api_users, :key
  end

end
