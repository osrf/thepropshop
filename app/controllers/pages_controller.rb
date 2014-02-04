class PagesController < ApplicationController

  def index
    addBreadcrumb "Home", :root
    @post = params
    @categories = Category.where("model_count > 0")
    @allCategories = Category.all
  end

  def about
    addBreadcrumb "About", about_path()
    @post = params
  end

  def find
    addBreadcrumb "Find", request.original_url
    @post = params
    @categories = Category.where("model_count > 0")
    @allCategories = Category.all
  end


  def search
    @post = params
    @allCategories = Category.all
    addBreadcrumb "Search", request.original_url 

    @models = []

    if params[:tag]
      @models = Model.where("tags LIKE ?", "%#{params[:tag]}%")
    elsif params[:category]
      if params[:category] == "All Categories"
        @models = Model.where(
          "name LIKE ? OR description LIKE ? OR tags like ?",
          "%#{params[:search]}%",
          "%#{params[:search]}%",
          "%#{params[:search]}%")

        # Add in models that match a username
        users = User.where("username LIKE ?", "%#{params[:search]}%")
        users.each do |user|
          @models += Model.where("creator == ?", user.id)
        end
      elsif params[:category] != "Username"
        @models = Model.where(
          "(name LIKE ? OR description LIKE ? OR tags LIKE ?) AND category = ?",
          "%#{params[:search]}%",
          "%#{params[:search]}%",
          "%#{params[:search]}%",
          params[:category].singularize)
      else
        users = User.where("username LIKE ?", "%#{params[:search]}%")
        users.each do |user|
          @models += Model.where("creator == ?", user.id)
        end
      end
    else
      @models = Model.where(
        "name LIKE ? OR description LIKE ? OR tags LIKE ? OR category LIKE ?",
        "%#{params[:search]}%",
        "%#{params[:search]}%",
        "%#{params[:search]}%",
        "%#{params[:search]}%")

      users = User.where("username LIKE ?", "%#{params[:search]}%")
      users.each do |user|
        @models += Model.where("creator == ?", user.id)
      end
    end

    #if params[:category]
    #  if params[:category] == "All Categories"
    #    @models = Model.where(
    #      "name LIKE ? OR description LIKE ? OR tags like ?",
    #      "%#{params[:search]}%",
    #      "%#{params[:search]}%",
    #      "%#{params[:search]}%")
    #  elsif params[:category] != "Username"
    #    @models = Model.where(
    #      "(name LIKE ? OR description LIKE ? OR tags LIKE ?) AND category = ?",
    #      "%#{params[:search]}%",
    #      "%#{params[:search]}%",
    #      "%#{params[:search]}%",
    #      params[:category].singularize)
    #  else
    #    users = User.where("username LIKE ?", "%#{params[:search]}%")
    #    users.each do |user|
    #      @models += Model.where("creator == ?", user.id)
    #    end
    #  end
    #elsif params[:tag]
    #    @models = Model.where("tags LIKE ?", "%#{params[:tag]}%")
    #end
  end

  def browse
    addBreadcrumb params[:category], request.original_url
    @post = params
    @models = []
    if params[:category] == "all"
      @models = Model.find(:all)
    else
      @models = Model.where(category: params[:category])
    end

    @models.sort!{|a,b| a.name.downcase <=> b.name.downcase}
  end

  def contact
    @post = params
    addBreadcrumb "Contact", request.original_url 
  end

  def email
    @post = params
    addBreadcrumb "Contact", request.original_url
  end

  def api
    @post = params
    addBreadcrumb "API", "pages/api"
  end

  def deploy
    @post = params
  end

end
