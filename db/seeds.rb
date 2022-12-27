require 'csv'
require 'activerecord-import'
require 'smarter_csv'


def link_postcodes_to_constituencies
  # Load the CSV file and parse it into a Ruby hash
  constituency_codes = SmarterCSV.process(File.open('/Users/dylandeehan/Downloads/postcodeCSV/constituency_codes.csv')).each_with_object({}) { |row, hash| hash[row[:PCON20CD]] = row[:PCON20NM] }
  # Find all the Postcode records that have a constituency_code
  postcodes = Postcode.where.not(constituency_code: nil)
  puts "these are the postcodes #{postcodes.inspect}"
  # Iterate over the Postcode records
  postcodes.each do |postcode|
    # Find the Constituency record with the matching name
    constituency = Constituency.find_by(name: constituency_codes[postcode.constituency_code])
    if constituency
      # Set the constituency_id on the Postcode record
      postcode.constituency_id = constituency.id
      postcode.save!
    end
  end
end






def seed_postcodes(csv_file_path)
  data = []
  total_postcodes = 0
  counter = 0

  puts "Starting postcode seed..."

  CSV.foreach(csv_file_path, headers: true) do |row|
    total_postcodes += 1
    data << extract_row_data(row)
    counter += 1
    print_progress(counter, total_postcodes)
    break if counter == 5000
  end

  puts "Total number of postcodes: #{total_postcodes}"

  Postcode.import(data, validate: false, parallel: true, batch_size: 1000) do |import|
    import.on_duplicate_key_update = [:postcode]
    import.on_batch_complete { |batch_results| print_percentage_processed(batch_results, total_postcodes) }
  end

  puts "Completed postcode seed"
end

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
    average_income: row["Average income"]
  }
end

def print_progress(counter, total_postcodes)
  puts "Processed #{counter} out of #{total_postcodes} postcodes" if counter % 1000 == 0
end

def print_percentage_processed(batch_results, total_postcodes)
  counter = batch_results.sum { |r| r[:num_inserted] }
  percentage = (counter.to_f / total_postcodes.to_f) * 100
  puts "#{percentage}% of postcodes processed"
end

seed_postcodes("/Users/dylandeehan/Downloads/postcodeCSV/postcodes.csv")


def create_constituency
  puts "making"
  @constituency_skip = 0
  @constituencies = []
  loop do
    # puts "Current constituency_skip value: #{@constituency_skip}"
    # begin block to handle any exceptions
    begin
      # http get request from the restclient library
      @response = RestClient.get("https://members-api.parliament.uk/api/Location/Constituency/Search?skip=#{@constituency_skip}&take=20")

      # retrieve the body of the @response object and parse it into a ruby hash
      @response_body = @response.body
      @parsed = JSON.parse(@response_body)
      # break the loop if @parsed is empty
      if @parsed["items"] == []
        break
      end
      @parsed["items"].each do |individual|
        @constituency =  individual["value"]
        # puts @constituency # prints the name of the constituency
        @constituencies.push(@constituency)
        puts "constituencies length is #{@constituencies.length}" # prints the name of the constituency
      end
      @constituency_skip += 20
      # puts "Current length of @constituencies: #{@constituencies.length}"
      # Handle errors or exceptions
    rescue RestClient::ExceptionWithResponse => e
      puts "Error: #{e.message}"
      puts "Status code: #{e.response.code}"
      break if @repos.empty?
    end
  end
end

# call the create_constituency function
create_constituency

# iterate over the @constituencies array and create a new constituency object for each constituency
@constituencies.each do |constituency_data|
  # see if the seat is vacant so can set when constituency is created
  if constituency_data["currentRepresentation"].nil?
    seat_vacant = true
  else
    seat_vacant = false
  end
  Constituency.create!(
    constituency_id: constituency_data["id"],
    name: constituency_data["name"],
    seat_vacant: seat_vacant
  )
end
link_postcodes_to_constituencies
def create_member
  @member_skip = 0
  @members = []
  loop do
    puts "Current member_skip value: #{@member_skip}"
    # begin block to handle any exceptions
    begin
      # http get request from the restclient library
      @response = RestClient.get("https://members-api.parliament.uk/api/Members/Search?House=1&IsCurrentMember=true&skip=#{@member_skip}&take=20")
      # retrieve the body of the @response object and parse it into a ruby hash
      @response_body = @response.body
      @parsed = JSON.parse(@response_body)
      # break the loop if @parsed is empty
      if @parsed["items"] == []
        break
      end
      @parsed["items"].each do |individual|
        @member =  individual["value"]
        # puts @member # prints the name of the member
        @members.push(@member)
      end
      @member_skip += 20
      puts "Current length of @members: #{@members.length}"
      # Handle errors or exceptions
    rescue RestClient::ExceptionWithResponse => e
      puts "Error: #{e.message}"
      puts "Status code: #{e.response.code}"
      break if @repos.empty?
    end
  end
end

# call the create_member function
create_member


# iterate over the @members array and create a new Member object for each member
@members.each do |member_data|
  Member.create!(
    member_id: member_data["id"],
    name_display_as: member_data["nameDisplayAs"],
    party: member_data["latestParty"]["name"],
    party_id: member_data["latestParty"]["id"],
    gender: member_data["gender"],
    constituency_id: member_data["latestHouseMembership"]["membershipFromId"],
    house: member_data["latestHouseMembership"]["house"],
    membership_start_date: member_data["latestHouseMembership"]["membershipStartDate"],
    thumbnail_url: member_data["thumbnailUrl"]
  )

end
