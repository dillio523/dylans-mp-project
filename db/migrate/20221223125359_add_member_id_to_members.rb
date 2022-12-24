class AddMemberIdToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :member_id, :integer
  end
end
