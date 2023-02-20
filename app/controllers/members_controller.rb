class MembersController < ApplicationController

  def index
    @members = Member.all
  end

  # def show
  #   member_id = params[:id]
  #   response = HTTParty.get("https://members-api.parliament.uk/api/Members/#{member_id}/Contact")
  #   @contact_information = JSON.parse(response.body)
  # end
end
