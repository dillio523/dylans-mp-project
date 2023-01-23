require 'csv'
require 'activerecord-import'
require 'smarter_csv'

  def create_constituency
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
  end
