
class ConstituenciesController < ApplicationController
  def index
    @constituencies = Constituency.all
  end

end
