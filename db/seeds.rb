require 'csv'
require 'activerecord-import'
require 'smarter_csv'
# measuring how seed takes to run for comparison
start_time = Time.now
def link_postcodes_to_constituencies
  # Get all postcodes that have a non-empty constituency name
  total_postcodes = postcodes.count
  counter = 0

  puts "Starting postcode linking..."

  # Use a single update query to update all postcodes at once
  Postcode.where.not(constituency_name: [nil, ""]).update_all(
    "constituency_id = (SELECT constituency_id FROM constituencies WHERE LOWER(name) = LOWER(postcodes.constituency_name))"
  )

  # Print progress every 1000 postcodes
  postcodes.each do |postcode|
    counter += 1
    if counter % 1000 == 0
      print_percentage_processed(counter, total_postcodes)
    end
  end

  puts "Completed postcode linking"
  end_time = Time.now
  postcode_linking_duration = end_time - start_time
  puts "Total duration for link_postcodes_to_constituencies: #{postcode_linking_duration / 60} minutes"
end

def print_percentage_processed(counter, total_postcodes)
  percentage = (counter.to_f / total_postcodes.to_f) * 100
  puts "#{percentage}% of postcodes linked"
end


def seed_postcodes(csv_file_path)
  start_time = Time.now
  data = []
  total_postcodes = 0
  counter = 0

  puts "Starting postcode seed..."
  puts "starting csv each"
  csv_each_start_time = Time.now
  CSV.foreach(csv_file_path, headers: true) do |row|
    total_postcodes += 1
    data << extract_row_data(row)
    counter += 1
    print_progress(counter, total_postcodes)
    # break if counter == 5000
  end
  puts "completed csv_each"
  csv_each_end_time = Time.now
  csv_each_duration = csv_each_end_time - csv_each_start_time
  puts "Total time taken for csv_each: #{csv_each_duration / 60} minutes"

  puts "starting postcode import"
  postcode_import_start_time = Time.now

  Postcode.import(data, validate: false, parallel: true, batch_size: 1000) do |import|
    import.on_duplicate_key_update = [:postcode]
    import.on_batch_complete { |batch_results| print_percentage_processed_batch(batch_results, total_postcodes) }
  end
  puts "finished postcode_import"
  postcode_import_end_time = Time.now
  postcode_import_duration = postcode_import_end_time - postcode_import_start_time
  puts "postcode import duration: #{postcode_import_duration / 60} minutes"

  puts "Completed postcode seed"
  end_time = Time.now
  seed_postcode_duration = end_time - start_time
  puts "Total time taken for seed_postcodes: #{seed_postcode_duration / 60} minutes"
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
    average_income: row["Average income"],
    constituency_name: row["Constituency"]
  }
end

def print_progress(counter, total_postcodes)
  puts "Processed #{counter} out of #{total_postcodes} postcodes" if counter % 1000 == 0
end

def print_percentage_processed_batch(batch_results, total_postcodes)
  counter = batch_results.sum { |r| r[:num_inserted] }
  percentage = (counter.to_f / total_postcodes.to_f) * 100
  puts "#{percentage}% of postcodes processed"
end

seed_postcodes("/Users/dylandeehan/Downloads/postcodeCSV/postcodes.csv")

def create_constituency
  start_time = Time.now
  puts "starting create_constituency"
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
  end_time = Time.now
  create_constit_duration = end_time - start_time
  puts "Total time taken for create_constituency: #{create_constit_duration / 60} minutes"
end

# call the create_constituency function
create_constituency

# iterate over the @constituencies array and create a new constituency object for each constituency
puts "starting constituency_each"
constituency_each_start_time = Time.now
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
puts "Completed constituency_each"
constituency_each_end_time = Time.now
constituency_duration = constituency_each_end_time - constituency_each_start_time
puts "Total time taken for constituency_each: #{constituency_duration / 60} minutes"

link_postcodes_to_constituencies
def create_member
  puts "starting create_member"
  start_time = Time.now
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
  puts "Completed create_member"
  end_time = Time.now
  create_memb_duration = end_time - start_time
  puts "Total time taken for create_member: #{create_memb_duration / 60} minutes"
end

# call the create_member function
create_member


# iterate over the @members array and create a new Member object for each member
puts "starting members_each"
members_each_start_time = Time.now
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
puts "Completed members_each"
end_time = Time.now
total_time = End_time - start_time
puts "Total time taken: #{total_time / 60} minutes"
