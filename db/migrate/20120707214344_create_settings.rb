class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :region, :null => false
      t.string :key, :null => false
      t.string :value, :null => false
      t.timestamps
    end

    add_index :settings, :region
    add_index :settings, :key

  end
end
