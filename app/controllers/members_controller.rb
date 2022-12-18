require "rest-client"
require "json"

class MembersController < ApplicationController

  def index
    @members = Member.all
  end

  def create
    @member = Member.new(member_params)

    if @member.save
      redirect_to @member, notice: 'Member was successfully created.'
    else
      render :new
    end
  end

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

  private

  def member_params
    params.require(:member).permit(:name_list_as, :name_display_as, :name_full_title, :name_address_as, :party, :gender, :membership_from, :membership_from_id, :house, :membership_start_date, :membership_end_date, :membership_end_reason, :membership_end_reason_notes, :membership_end_reason_id, :membership_status, :status_description, :status_notes, :status_id, :status_start_date, :thumbnail_url)
  end
end
