require 'rails_helper'


RSpec.describe "Access management", :type => :system do
  let(:user_params){
    {
      first_name: "John123456",
      last_name: "Doe123456",
      email: "john.doe123456@email.com",
      password: "password"
    }
  }

  before do
    driven_by(:rack_test)
  end

  it "enables a user to sign up" do
    VCR.use_cassette("get_index") do
      visit "/"
    end
    click_link "Sign in"
    click_link "sign-up"

    within("//#signUpModal") do
      fill_in "user_first_name", with: user_params[:first_name]
      fill_in "user_last_name", with: user_params[:last_name]
      fill_in "user_email", with: user_params[:email]
      fill_in "user_password", with: user_params[:password]
      VCR.use_cassette("sign_up") do
        click_button "Submit"
      end
    end

    expect(page).to have_text("User created successfully.")
  end

  it "enables a user to sign in" do
    sign_in

    expect(page).to have_text("Signed in successfully.")
  end

  it "enables a user to sign out" do
    sign_in
    VCR.use_cassette("sign_out") do
      click_link "Sign out"
    end

    expect(page).to have_text("Signed out successfully.")
  end
end
