class AddConstituencyIdToPostcodes < ActiveRecord::Migration[7.0]
  def change
    add_column :postcodes, :constituency_id, :integer
  end
end
