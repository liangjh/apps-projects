class AddSuperUserToUser < ActiveRecord::Migration

  def up
    add_column :users, :super_user, :boolean
  end


  def down
    remove_column :users, :super_user
  end


end
