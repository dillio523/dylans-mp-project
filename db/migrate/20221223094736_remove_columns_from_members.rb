class RemoveColumnsFromMembers < ActiveRecord::Migration[7.0]
  def change
    remove_column :members, :membership_end_date, :datetime
    remove_column :members, :membership_end_reason, :string
    remove_column :members, :membership_end_reason_notes, :text
    remove_column :members, :name_address_as, :string
    remove_column :members, :name_full_title, :string
    remove_column :members, :name_list_as, :string
  end
end
