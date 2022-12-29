class ChangeDataTypeForConstituencyId < ActiveRecord::Migration[7.0]
  def change
    change_column :constituencies, :constituency_id, :string
    add_column :constituencies, :constituency_name, :string
  end
end
