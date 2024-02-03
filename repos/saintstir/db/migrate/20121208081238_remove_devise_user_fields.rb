class RemoveDeviseUserFields < ActiveRecord::Migration


  def up

    # Remove all authentications
    remove_index :users, :name => "index_users_on_reset_password_token"

    # Remove all devise auth columns
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
    remove_column :users, :current_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
  end

  def down
    puts "*** UNFORTUNATELY, THERE IS NO ROLLBACK ***"
    raise ActiveRecord::IrreversibleMigration
  end

end
