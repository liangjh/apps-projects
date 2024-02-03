class AddGenderAndAgeGroupToUser < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :age_group, :string
  end
end
