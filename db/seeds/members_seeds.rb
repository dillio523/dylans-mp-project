require 'csv'
  require 'activerecord-import'
  require 'smarter_csv'

  def create_member
    puts "starting create_member"
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
    puts "Completed create_member"
  end
