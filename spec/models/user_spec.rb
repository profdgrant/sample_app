require 'spec_helper'

# The following are unit tests on the User class

describe User do

	# first create a new user	
  before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar") }

  # the context is that user
  subject { @user }

  # check that the user has the attributes that it should have
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token)}  # added to handle persistence across sessions


  # check that user satisfies any validation requirements
  it { should be_valid }

  # set the name attribute to blank, then check that it is not valid
	describe "when name is not present" do
		before { @user.name = "" }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = "" }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses =%w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses =%w[user@foo.COM A_US-ER@f.b.org frst.lst@foobar.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end	

	describe "when email address is already taken" do

		before do
			user_with_same_email = @user.dup  # create a user with the same email as the original one
			user_with_same_email.email = @user.email.upcase  # change the email to all upper-case
			user_with_same_email.save # save the new user to the database
		end

		it {should_not be_valid } # the original user should now not be valid - note : the original user has NOT been committed to the database
	end

	describe "email address with mixed case" do
		let(:mixed_case_email) {"Foo@ExAmPle.CoM"}

		it "should be saved as all lower case" do
			@user.email = mixed_case_email
			@user.save  #call back should ensure it is saved as lower case
			expect(@user.reload.email).to eq mixed_case_email.downcase # when reloaded, it should come back in lower case
		end
	end

	# Password requirements

	describe "when password is not present" do
		before do
			@user = User.new(name: "Example User", email: "user@example.com", password: "", password_confirmation: "")
		end
		it {should_not be_valid}
	end

	describe "when password does not match confirmation" do
		before {@user.password_confirmation = "mismatch"}  # all we are doing here is setting the confirmation to the string "mismatch"
		it {should_not be_valid}
	end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 } # sets password to a string that is too short
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }   # save the sample user to the database
    let(:found_user) { User.find_by(email: @user.email) }  #retrieve an item from the database which has the email of the sample user  

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }  #found_user and @user have matching passwords - recall that @user is the subject
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") } # see if the found user has password "invalid" - it should not!!
      # In fact, the authentication should fail, returning false	

      it { should_not eq user_for_invalid_password } # we should NOT have returned the original user
      specify { expect(user_for_invalid_password).to be_false } # as noted above we should have retunrned false
    end
  end
  # NOTE : The above tests are clunky, and there are better ways to do this!! (DDG)
  # NOTE again : The "tests" are actually a mixture of test and specification, although to be honest for a method like authenticate, 
  #              the behaviour is already given

  # when a new user is saved, it should have its remember token created; note that this test does not touch the database
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
    # above line is really : it {expect(@user.remember_token). not_to be-blank}
    # or, even better for an old hack like me : not(blank(@user.remember_token))
  end

end
