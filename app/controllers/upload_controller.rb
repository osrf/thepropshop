class UploadController < ApplicationController
  def index
    @post = params
    page = params[:page]
    if page == "2"
      self.render('page2')
    end
  end

  def page2
    @post = params
  end
end
