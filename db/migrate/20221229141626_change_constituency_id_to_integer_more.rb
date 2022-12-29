class ChangeConstituencyIdToIntegerMore < ActiveRecord::Migration[7.0]
  def change
    change_column :constituencies, :constituency_id, 'integer USING CAST(constituency_id AS integer)'
  end
end
