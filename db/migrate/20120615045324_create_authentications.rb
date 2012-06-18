class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.integer :user_id
      t.string :name
      t.timestamps
    end

    add_index(:authentications, :user_id)
  end
end
