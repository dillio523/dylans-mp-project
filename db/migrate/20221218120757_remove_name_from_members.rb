class RemoveNameFromMembers < ActiveRecord::Migration[7.0]
  def change
    remove_column :members, :name, :string
  end
end
