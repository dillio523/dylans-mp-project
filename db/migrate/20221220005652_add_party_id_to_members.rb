class AddPartyIdToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :party_id, :integer
  end
end
