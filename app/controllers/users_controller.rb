class UsersController < ApplicationController
  def index
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to '/success'
    else
      render 'new'
    end
  end
  def success
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :postcode)
  end
end
