require 'csv'
require 'activerecord-import'
require 'smarter_csv'


def seed_postcodes(csv_file_path)
  puts "Starting postcode seed..."
  data = []
  counter = 0
  def extract_row_data(row)
    {
      postcode: row["Postcode"],
      latitude: row["Latitude"],
      longitude: row["Longitude"],
      county: row["County"],
      district: row["District"],
      ward: row["Ward"],
      population: row["Population"],
      region: row["Region"],
      constituency_code: row["Constituency Code"],
      index_of_multiple_deprivation: row["Index of Multiple Deprivation"],
      distance_to_station: row["Distance to station"],
      average_income: row["Average income"],
      constituency_name: row["Constituency"]
    }
  end
  CSV.foreach(csv_file_path, headers: true) do |row|
    # break if counter == 5000
      data << extract_row_data(row)      # remove line below when finished testing
      end
  puts "starting postcode import"

  Postcode.import(data, validate: false, parallel: true, batch_size: 1000) do |import|
    import.on_duplicate_key_update = [:postcode]
  end
  puts "Completed postcode seed"
end
