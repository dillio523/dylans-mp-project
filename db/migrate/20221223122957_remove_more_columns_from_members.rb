class RemoveMoreColumnsFromMembers < ActiveRecord::Migration[7.0]
  def change
    remove_column :members, :membership_from, :string
    remove_column :members, :membership_end_reason_id, :integer
    remove_column :members, :membership_status, :boolean
    remove_column :members, :status_description, :string
    remove_column :members, :status_notes, :string
    remove_column :members, :status_id, :integer
    remove_column :members, :status_start_date, :datetime
  end
end
