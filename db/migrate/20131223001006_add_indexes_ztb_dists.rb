class AddIndexesZtbDists < ActiveRecord::Migration

  def up

    #  Z-distribution
    add_index :z_dists, :zv
    add_index :z_dists, :p_lt_zv
    add_index :z_dists, :p_gt_zv

    #  T-distribution
    add_index :t_dists, [:df, :alpha]
    add_index :t_dists, [:df, :tv_1t]
    add_index :t_dists, [:df, :tv_2t]

    #  Binomial distribution
    add_index :binomial_dists, [:n_trials, :x_success]
    add_index :binomial_dists, [:n_trials, :p_population]

  end

  def down

    #  Z-distribution
    remove_index :z_dists, :zv
    remove_index :z_dists, :p_lt_zv
    remove_index :z_dists, :p_gt_zv

    #  T-distribution
    remove_index :t_dists, [:df, :alpha]
    remove_index :t_dists, [:df, :tv_1t]
    remove_index :t_dists, [:df, :tv_2t]

    #  Binomial distribution
    remove_index :binomial_dists, [:n_trials, :x_success]
    remove_index :binomial_dists, [:n_trials, :p_population]
  end

end
