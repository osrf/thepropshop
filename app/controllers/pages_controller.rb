class PagesController < ApplicationController
  def index
    @post = params
  end

  def about
    @post = params
  end

  #def upload
  #  @post = params
  #end
end
