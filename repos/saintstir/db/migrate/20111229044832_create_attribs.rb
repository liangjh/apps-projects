class CreateAttribs < ActiveRecord::Migration

  def change

    create_table :attribs do |t|
      t.primary_key :id
      t.integer :attrib_category_id, :null => false
      t.string :code, :null => false
      t.string :name, :null => false
      t.string :description
      t.integer :ord
      t.boolean :visible
      t.timestamps
    end

    add_index(:attribs, :attrib_category_id)
    add_index(:attribs, :name)
    add_index(:attribs, :code)

  end

end
