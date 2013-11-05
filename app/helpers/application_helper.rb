module ApplicationHelper

  def addBreadcrumb(_name, _url)
    if session[:breadcrumbss].nil?
      session[:breadcrumbss] = []
    end

    exists = false
    session[:breadcrumbss].each_with_index do |crumb, index|
      if crumb[:name] == _name
        exists = true
        # Remove breadcrumbs that are ahead of the current URL
        session[:breadcrumbss].slice!(index+1, session[:breadcrumbss].length)
        break
      end
    end

    if !exists
      session[:breadcrumbss] << {:name=>_name, :url=>_url}
    end
  end

  def breadcrumbs
    if not session[:breadcrumbss].nil?
      render partial: "shared/breadcrumbs", locals: {crumbs: session[:breadcrumbss]}
    end
  end
end
