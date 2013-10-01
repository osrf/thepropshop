class UserController < ApplicationController
  def create
    @post = params
    user = User.find(params[:id])
    user.username = params[:user][:username]
    user.save
    redirect_to root_path
  end

  ###############################################
  # Display downloads for a user
  def downloads
    @post = params
    @downloads = Downloads.where(:user_id=>current_user.id)
  end

  ###############################################
  # Display models created by a user
  def created
    @post = params
    @models = Model.where(:creator=>current_user.id)
  end

  ###############################################
  # Display models user likes
  def likes
    @post = params
    @likes = Likes.where(:user_id=>current_user.id, :value=>true)
  end

end
