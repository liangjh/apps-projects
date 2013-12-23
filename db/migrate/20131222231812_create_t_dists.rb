class CreateTDists < ActiveRecord::Migration
  def change
    create_table :t_dists do |t|
      t.integer :df
      t.float :alpha
      t.float :p_cum
      t.float :tv_2t
      t.float :tv_1t

      t.timestamps
    end
  end
end
