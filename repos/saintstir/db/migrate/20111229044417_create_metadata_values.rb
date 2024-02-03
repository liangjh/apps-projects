class CreateMetadataValues < ActiveRecord::Migration
  def change

    create_table :metadata_values do |t|
      t.primary_key :id
      t.integer :saint_id, :null => false
      t.integer :metadata_key_id, :null => false
      t.string :value
      t.text :value_text
      t.integer :ord
      t.boolean :visible

      t.timestamps
    end

    add_index(:metadata_values, :saint_id)
    add_index(:metadata_values, :metadata_key_id)


  end
end
