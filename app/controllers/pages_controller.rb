class PagesController < ApplicationController
  def index
    @post = params
    @categories = Category.all
  end

  def about
    @post = params
  end

  def category
    @post = params
  end

  def search
    @post = params
  end

  #def upload
  #  @post = params
  #end
end
