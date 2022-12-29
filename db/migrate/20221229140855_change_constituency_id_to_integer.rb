class ChangeConstituencyIdToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :postcodes, :constituency_id, :integer
  end
end
