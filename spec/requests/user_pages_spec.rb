require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do  # submit an empty form; this should be rejected as invalid
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end


      describe "after submission" do
        before { click_button submit }  ## note that we again submit an empty form; be aware that we just test ONE kind of bad submission here

        it { should have_title('Sign up') }  # return to signup page
        it { should have_content('error') }  # show the error messages
      end
    end

    describe "with valid information" do # submit a form with an example of correct data (nb - ensure email is not duplicate)
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }  # retrieve item with the just-added email, and check that name is the just-added name
        it { should have_link('Sign out')} # page should have the sign-out link : CURRENTLY BROKEN - DON'T KNOW WHY!
        it { should have_title(user.name) }  # the User page for the just-added user should be displayed
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end


    end
  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }  # creates a user using the Factory Girl gem; code in spec/factories.rb
  	before { visit user_path(user)}

  	it {should have_content(user.name)}
  	it {should have_title(user.name)}
  end

end
