class CreateAttribCategories < ActiveRecord::Migration
  def change

    create_table :attrib_categories do |t|
      t.primary_key :id
      t.string :code, :null => false
      t.string :name, :null => false
      t.string :description
      t.boolean :visible
      t.boolean :multi

      t.timestamps
    end

    add_index(:attrib_categories, :name)
    add_index(:attrib_categories, :code)

  end
end
