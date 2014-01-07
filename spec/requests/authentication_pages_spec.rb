require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }   # signing in without any submitted info, so should fail

      it { should have_title('Sign in') }  # should get the sign-in page back again
      it { should have_selector('div.alert.alert-error') }  # should have error message

      describe "after visiting another page" do
      	before {click_link "Home" }
      	it {should_not have_selector('div.alert.alert-error')}
      end

    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }  # simulate sign-in of an existing user
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) } # have_link is a Capybara method
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
      	before {click_link "Sign out"}
      	it {should have_link('Sign in')}
      end

    end
  end
end