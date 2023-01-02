class PostcodesController < ApplicationController
  def search
    @postcode = Postcode.find_by(postcode: params[:q])
    if @postcode
      redirect_to postcode_path(@postcode)
    end
  end

  def show
    @postcode = Postcode.find(params[:id])
    @constituency = @postcode.constituency
    @member = @constituency.member
  end
end
