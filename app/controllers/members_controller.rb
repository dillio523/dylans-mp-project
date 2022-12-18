require "rest-client"
require "json"

class MembersController < ApplicationController
  def index
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
          @member = {}
          @member["name"] = individual["value"]["nameListAs"] # access the name of the member
          puts @member # prints the name of the member
          @members.push(@member)
        end
        @skip += 20
        puts "Current length of @members: #{@members.length}"
        # Handle errors or exceptions
      rescue RestClient::ExceptionWithResponse => e
        puts "Error: #{e.message}"
        puts "Status code: #{e.response.code}"
        break if @repos.empty?
      end
    end
  end
end
