class ApplicationController < ActionController::Base
  def current_login
    if session[:current_logged_email]
      Access.new email: session[:current_logged_email]
    end
  end
  alias_method :current_access, :current_login
  helper_method :current_login, :current_access

  def current_access_token
    current_login.try(:access_token)
  end
end
