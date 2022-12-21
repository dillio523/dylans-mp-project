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
  
  private

  def member_params
    params.require(:member).permit(:name_list_as, :name_display_as, :name_full_title, :name_address_as, :party, :gender, :membership_from, :membership_from_id, :house, :membership_start_date, :membership_end_date, :membership_end_reason, :membership_end_reason_notes, :membership_end_reason_id, :membership_status, :status_description, :status_notes, :status_id, :status_start_date, :thumbnail_url, :party_id)
  end
end
