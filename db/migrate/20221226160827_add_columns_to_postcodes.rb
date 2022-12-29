class AddColumnsToPostcodes < ActiveRecord::Migration[7.0]
  def change
    remove_column :postcodes, :pcds
    remove_column :postcodes, :pcon
    add_column :postcodes, :postcode, :string
    add_column :postcodes, :latitude, :float
    add_column :postcodes, :longitude, :float
    add_column :postcodes, :county, :string
    add_column :postcodes, :district, :string
    add_column :postcodes, :ward, :string
    add_column :postcodes, :population, :integer
    add_column :postcodes, :region, :string
    add_column :postcodes, :constituency_code, :string
    add_column :postcodes, :index_of_multiple_deprivation, :integer
    add_column :postcodes, :distance_to_station, :float
    add_column :postcodes, :average_income, :float
  end
end
