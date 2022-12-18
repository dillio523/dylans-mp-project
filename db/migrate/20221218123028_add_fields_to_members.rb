class AddFieldsToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :name_list_as, :string
    add_column :members, :name_display_as, :string
    add_column :members, :name_full_title, :string
    add_column :members, :name_address_as, :string
    add_column :members, :party, :string
    add_column :members, :gender, :string
    add_column :members, :membership_from, :string
    add_column :members, :membership_from_id, :integer
    add_column :members, :house, :integer
    add_column :members, :membership_start_date, :datetime
    add_column :members, :membership_end_date, :datetime
    add_column :members, :membership_end_reason, :string
    add_column :members, :membership_end_reason_notes, :string
    add_column :members, :membership_end_reason_id, :integer
    add_column :members, :membership_status, :boolean
    add_column :members, :status_description, :string
    add_column :members, :status_notes, :string
    add_column :members, :status_id, :integer
    add_column :members, :status_start_date, :datetime
    add_column :members, :thumbnail_url, :string
  end
end
