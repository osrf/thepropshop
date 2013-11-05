class UserController < ApplicationController

  ###############################################
  # \brief Get information about the user
  def index
    if signed_in?
      user = current_user
      render :json=>{:username=>user.username}
    else
      render :json=>{:username=>"anonymous"}
    end
  end

  def destroy
    printf("\n\n\n\n\n\n DELETE USER\n\n\n\n\n\n")
    if User.find(params[:id])
      if signed_in? and current_user.id == params[:id]
        logout
      end
      User.destroy(params[:id])
    end
    render :json=>{:status => "success"}
  end

  ###############################################
  # \brief Create a new user
  def create
    @post = params
    user = User.where(username: params[:user][:username]).first
    msg = ""
    status = ""

    if user
      status = "failure"
      msg = "Username already exists. Please try again."
    else
      user = User.find(params[:id])
      user.username = params[:user][:username]
      user.save

      msg = params[:user][:username]
      status = "success"
    end

    render :json=>{:status=> status, :message => msg}
  end

  ###############################################
  # Display downloads for a user
  def downloads
    @post = params
    @downloads = Downloads.where(:user_id=>current_user.id)
    add_breadcrumb "Downloads", "/user/#{current_user.id}/downloads"
  end

  ###############################################
  # Display models created by a user
  def created
    @post = params
    @models = Model.where(:creator=>current_user.id)
    add_breadcrumb "Created", "/user/#{current_user.id}/created"
  end

  ###############################################
  # Display models user likes
  def likes
    @post = params
    @likes = Likes.where(:user_id=>current_user.id, :value=>true)
    add_breadcrumb "Likes", "/user/#{current_user.id}/likes"
  end

end
