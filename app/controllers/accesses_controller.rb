class AccessesController < ApplicationController
  def create
    @access = Access.new(email: params[:email], password: params[:password])
    if @access.save
      session[:current_logged_email] = @access.email
      redirect_to widgets_path, notice: "Signed in successfully."
    else
      redirect_to root_path, alert: "Signed in failed: #{@access.error_message}."
    end
  end

  def destroy
    if current_access.destroy
      session[:current_logged_email] = nil
      redirect_to root_path, notice: "Signed out successfully."
    else
      redirect_to root_path, alert: "Sign out failed: #{current_access.error_message}"
    end
  end
end
