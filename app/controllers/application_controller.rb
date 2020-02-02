class ApplicationController < ActionController::Base
  def current_login
    @current_login ||= if session[:current_logged_email]
      access = Access.new email: session[:current_logged_email]
      if access.token_data
        access
      else
        if access.save
          access
        else
          session[:current_logged_email] = nil
        end
      end
    end
  end
  alias_method :current_access, :current_login
  helper_method :current_login, :current_access, :current_user

  def current_access_token
    current_login.try(:access_token)
  end

  def current_user
    @current_user ||= User.me(current_access)
  end

private
  def check_logged_in
    unless current_access
      redirect_to root_path, alert: "Please sign in first."
    end
  end
end
