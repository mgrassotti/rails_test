require 'rails_helper'


RSpec.describe "Access management", :type => :system do
  let(:user_params){
    {
      email: "john.doe123124e22@email.com",
      password: "password"
    }
  }

  before do
    driven_by(:rack_test)
    sign_in
  end

  it "enables a user to create a new widget" do
    VCR.use_cassette("get_index_logged_in") do
      visit "/"
    end
    click_link "Add a new widget"
    fill_in "widget_name", with: "Test Widget"
    fill_in "widget_description", with: "Visible Widget"
    select "visible"
    within("//form[action='/widgets/']") do
      VCR.use_cassette("create_widget") do
        click_button "Submit"
      end
    end

    expect(page).to have_text("Widget was successfully created.")
  end

  it "enables a user to edit a new widget" do
    VCR.use_cassette("get_my_widgets_index") do
      visit "/widgets/mine"
    end

    VCR.use_cassette("edit_widget") do
      click_link "Edit"
    end
    fill_in "widget_name", with: "Test edit Widget"
    VCR.use_cassette("update_widget") do
      within("//form[action^='/widgets/']") do
        click_button "Submit"
      end
    end

    expect(page).to have_text("Widget was successfully updated.")
    expect(page).to have_text("Test edit Widget")
  end

  it "enables a user to delete a widget" do
    VCR.use_cassette("get_my_widget_index") do
      visit "/widgets/mine"
    end

    VCR.use_cassette("delete_widget") do
      click_link "Delete"
    end
    expect(page).to have_text("Widget was successfully destroyed.")
  end
end
