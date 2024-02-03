class CreateZDists < ActiveRecord::Migration
  def change
    create_table :z_dists do |t|
      t.float :zv
      t.float :p_lt_zv
      t.float :p_gt_zv

      t.timestamps
    end
  end
end
