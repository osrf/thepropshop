module SessionsHelper
  def sign_in(user, redirect)
    cookies.permanent[:remember_token] = user.id
    self.current_user = user
    #redirect_to eval(redirect)
    redirect_to redirect
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_id(cookies[:remember_token])
  end

  def signed_in?
    !current_user.nil?
  end

  def logout
    self.current_user= nil
    cookies.delete(:remember_token)
  end
end
