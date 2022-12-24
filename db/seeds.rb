# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

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
        # @member["name"] = individual["value"]["nameListAs"] # access the name of the member
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
  #
end

def empty_seater_check
  @constits = Constituency.all
  @constits.each do

  end
end
