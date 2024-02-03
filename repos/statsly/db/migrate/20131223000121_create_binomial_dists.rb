class CreateBinomialDists < ActiveRecord::Migration
  def change
    create_table :binomial_dists do |t|
      t.integer :n_trials
      t.integer :x_success
      t.float :p_population
      t.float :p_cum
      t.float :p_point

      t.timestamps
    end
  end
end
