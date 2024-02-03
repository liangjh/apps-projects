class CreateSaints < ActiveRecord::Migration
  def change

    create_table :saints do |t|
      t.primary_key :id
      t.string :symbol, :null => false
      t.timestamps
    end

    add_index(:saints, :symbol, :unique => true)

  end
end
