class ModelController < ApplicationController
  def index
    @post = params
  end

  def new
    @post = params
    case @post[:step] 
    when "2"
      self.render("new_details")
    when "3"
      self.render("new_finish")
    else
      self.render('new')
    end
  end

  def new_details
    @post = params
  end

  def new_finish
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
