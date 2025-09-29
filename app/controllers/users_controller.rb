class UsersController < ApplicationController
  before_action :authenticate_user! 
  before_action :authorize_admin

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "User created."
    else
      render :new
    end
  end

  private
  def authorize_admin
    authorize User
  end

  def user_params
    params.require(:user).permit(:email, :password, :role)
  end
end
