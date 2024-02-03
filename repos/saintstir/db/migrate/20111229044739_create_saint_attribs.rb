class CreateSaintAttribs < ActiveRecord::Migration
  def change

    create_table :saint_attribs do |t|
      t.primary_key :id
      t.integer :saint_id, :null => false
      t.integer :attrib_id, :null => false

      t.timestamps
    end

    add_index(:saint_attribs, :saint_id)
    add_index(:saint_attribs, :attrib_id)
    add_index(:saint_attribs, [:saint_id, :attrib_id], :unique => true)


  end
end
