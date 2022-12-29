class AddConstituencyNameToPostcodes2 < ActiveRecord::Migration[7.0]
  def change
    add_column :postcodes, :constituency_name, :string
    remove_column :constituencies, :constituency_name, :string
  end
end
