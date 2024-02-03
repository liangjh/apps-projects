class CreateSaintEditAudit < ActiveRecord::Migration

  def change
    create_table :saint_edit_audits do |t|
      t.primary_key :id
      t.integer :saint_id, :null => false
      t.string :edited_by, :null => false
      t.string :comment
      t.timestamps
    end
  end

end
