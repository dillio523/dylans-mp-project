# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
def create_member
  @skip = 0
  @members = []
  loop do
    puts "Current skip value: #{@skip}"
    # begin block to handle any exceptions
    begin
      # http get request from the restclient library
      @response = RestClient.get("https://members-api.parliament.uk/api/Members/Search?House=1&IsCurrentMember=true&skip=#{@skip}&take=20")
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
        puts @member # prints the name of the member
        @members.push(@member)
      end
      @skip += 20
      # puts "Current length of @members: #{@members.length}"
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
    name_list_as: member_data["nameListAs"],
    name_display_as: member_data["nameDisplayAs"],
    name_full_title: member_data["nameFullTitle"],
    name_address_as: member_data["nameAddressAs"],
    party: member_data["latestParty"]["name"],
    gender: member_data["gender"],
    membership_from: member_data["latestHouseMembership"]["membershipFrom"],
    membership_from_id: member_data["latestHouseMembership"]["membershipFromId"],
    house: member_data["latestHouseMembership"]["house"],
    membership_start_date: member_data["latestHouseMembership"]["membershipStartDate"],
    membership_end_date: member_data["latestHouseMembership"]["membershipEndDate"],
    membership_end_reason: member_data["latestHouseMembership"]["membershipEndReason"],
    membership_end_reason_notes: member_data["latestHouseMembership"]["membershipEndReasonNotes"],
    membership_end_reason_id: member_data["latestHouseMembership"]["membershipEndReasonId"],
    membership_status: member_data["latestHouseMembership"]["membershipStatus"]["statusIsActive"],
    status_description: member_data["latestHouseMembership"]["membershipStatus"]["statusDescription"],
    status_notes: member_data["latestHouseMembership"]["membershipStatus"]["statusNotes"],
    status_id: member_data["latestHouseMembership"]["membershipStatus"]["statusId"],
    status_start_date: member_data["latestHouseMembership"]["membershipStatus"]["statusStartDate"],
    thumbnail_url: member_data["thumbnailUrl"]
  )
end
