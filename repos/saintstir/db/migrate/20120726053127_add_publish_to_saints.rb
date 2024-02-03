class AddPublishToSaints < ActiveRecord::Migration
  def up
    add_column :saints, :publish, :boolean, :default => false
    Saint.all.each do |saint|
      saint.publish = false
      saint.save
    end
  end
  def down
    remove_column :saints, :publish
  end
end
