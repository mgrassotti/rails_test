class UsersController < ApplicationController
  before_action :check_logged_in, only: [:show]

  def create
    @user = User.new(user_params)
    if @user.save
      session[:current_logged_email] = @user.email
      redirect_to root_path, notice: "User created successfully."
    else
      redirect_to root_path,
        alert: "User creation failed: #{@user.error_message}."
    end
  end

  def show
    result = User.find current_access, params[:id]
    if result[:status] == "ok"
      @user = result[:data]
    else
      redirect_to root_path, alert: result[:error_message]
    end
  end

  def reset_password
    @user = User.new(user_params)
    notification = if message = @user.reset_password
      { notice: message }
    else
      { alert: "Password reset failed: #{@user.error_message}." }
    end
    redirect_to root_path, notification
  end

private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
      :image_url)
  end
end
