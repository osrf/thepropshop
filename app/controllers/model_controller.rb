class ModelController < ApplicationController
  def index
  end

  def new
    @post = params
    # if @post[:step] == "2"
    #   self.render("new_details")
    # else
    #   self.render('new')
    # end
  end

  def new_details
    @post = params
  end

  def create
    @post = params
    self.render('new')
  end

  def show
    @pose = params
  end
end
