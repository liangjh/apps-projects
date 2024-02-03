class AddApiTermsOfUseFields < ActiveRecord::Migration
  def up
    add_column :api_users, :accepted_tou, :boolean
    add_column :api_users, :accepted_tou_ts, :datetime
  end

  def down
    remove_column :api_users, :accepted_tou
    remove_column :api_users, :accepted_tou_ts
  end
end
