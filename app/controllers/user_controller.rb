class UserController < ApplicationController
  def create
    @post = params
    p "\n\nUSER CREATE\n\n"
    p params
    p params[:user][:username]
    user = User.find(params[:id])
    user.username = params[:user][:username]
    user.save
    redirect_to root_path
  end
end
