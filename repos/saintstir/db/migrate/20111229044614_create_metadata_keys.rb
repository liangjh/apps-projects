class CreateMetadataKeys < ActiveRecord::Migration
  def change

    create_table :metadata_keys do |t|
      t.primary_key :id
      t.string :code, :null => false
      t.string :name, :null => false
      t.string :description
      t.string :meta_type
      t.boolean :multi

      t.timestamps
    end

    add_index(:metadata_keys, :code)
    add_index(:metadata_keys, :name)

  end
end
