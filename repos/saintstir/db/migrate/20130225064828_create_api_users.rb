class CreateApiUsers < ActiveRecord::Migration
  def change
    create_table :api_users do |t|
      t.string :key
      t.string :secret
      t.string :name
      t.string :email
      t.string :contact_details
      t.string :app_name
      t.boolean :active

      t.timestamps
    end

    add_index :api_users,  :key, :unique => true
    add_index :api_users, [:key, :secret]
  end
end
