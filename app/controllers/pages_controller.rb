class PagesController < ApplicationController

  def index
    @post = params
    @categories = Category.where("model_count > 0")
  end

  def about
    add_breadcrumb "About", about_path()
    @post = params
  end

  def search
    @post = params
    add_breadcrumb "Search", "pages/search/#{params}"

    if params[:category]
      if params[:category] == "All Categories"
        @models = Model.where(
          "name LIKE ? OR description LIKE ? OR tags like ?",
          "%#{params[:search]}%",
          "%#{params[:search]}%",
          "%#{params[:search]}%")
      else
        @models = Model.where(
          "(name LIKE ? OR description LIKE ? OR tags LIKE ?) AND category = ?",
          "%#{params[:search]}%",
          "%#{params[:search]}%",
          "%#{params[:search]}%",
          params[:category].singularize)
      end
    elsif params[:tag]
        @models = Model.where("tags LIKE ?", "%#{params[:tag]}%")
    else
      @model = []
    end
  end

  def browse
    add_breadcrumb params[:category], "pages/browse/#{params[:category]}"
    @post = params
    @models = Model.where(category: params[:category])
  end

end
