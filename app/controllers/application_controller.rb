class ApplicationController < ActionController::Base
  add_breadcrumb "Home", :root_path

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  def render_404
    render :text => 'Not Found', :status => '404'
  end
end
