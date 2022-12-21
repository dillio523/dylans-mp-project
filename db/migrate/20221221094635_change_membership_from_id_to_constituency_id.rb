class ChangeMembershipFromIdToConstituencyId < ActiveRecord::Migration[7.0]
  def change
    rename_column :members, :membership_from_id, :constituency_id
  end
end
