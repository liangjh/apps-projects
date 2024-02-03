class AddPrivilegedToApiUser < ActiveRecord::Migration
  def up
    add_column :api_users, :privileged, :boolean
  end
  def down
    remove_column :api_users, :privileged
  end
end
