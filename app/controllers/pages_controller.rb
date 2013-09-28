class PagesController < ApplicationController
  def index
    @post = params
    @categories = Category.where("model_count > 0")
  end

  def about
    @post = params
  end

  def category
    @post = params
  end

  def search
    @post = params
    if params[:scope] == "All Categories"
      @models = Model.where("name LIKE ? OR description LIKE ? OR tags like ?",
                            params[:pages][:search], params[:pages][:search],
                            params[:pages][:search])
    else
      @models = Model.where(
        "(name LIKE ? OR description LIKE ? OR tags LIKE ?) AND category = ?",
                            params[:pages][:search], params[:pages][:search],
                            params[:pages][:search], params[:scope].singularize)
    end
  end

  def browse
    @post = params
    @models = Model.where(category: params[:category])
  end

  #def upload
  #  @post = params
  #end
end
