class AddProfileColumnsToUser < ActiveRecord::Migration

  def up
    add_column :users, :anonymous, :boolean, :default => false
    add_column :users, :location_state, :string
    add_column :users, :location_country, :string
  end

  def down
    remove_column :users, :anonymous
    remove_column :users, :location_state
    remove_column :users, :location_country
  end

end
