module SessionsHelper

	def sign_in(user)
		# (1)generate a remember token, (2)assign this as a permanent cookie, (3)encrypt it and assign (in the database) as the user's remember token
		# and (4)set the "current user" to the user being signed in

    remember_token = User.new_remember_token

    cookies.permanent[:remember_token] = remember_token
    # Rails-provided cookies utility that allows cookies to be traeted as hashes
    
    user.update_attribute(:remember_token, User.encrypt(remember_token)) 
    # recall that update_attribute saves to the database after updating, and THERE IS NO VALIDATION!!
    # In a sign-in, it is an existing user that is signing in, and there is a new remember token generated for each sign-in.
    
    self.current_user = user
  end


  def signed_in?
    !current_user.nil?
  end




  # assignment to current user; remember in Ruby assignment has to be defined as a method
  def current_user=(user)
  	@current_user = user
  end

  # method to return the current user (setting it from the remember token if it is not set!)
  # the instance variable @current_user is reset when a page is left; so on a page re-direct, 
  # it needs to be re-established using the cookie
  def current_user
    remember_token = User.encrypt(cookies[:remember_token]) # get the token from the cookie
    @current_user ||= User.find_by(remember_token: remember_token) # find the user, and set the current user to this (if not already set)
  end


  def sign_out

  	# get a new remember token and update this for user (security measure)
    current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
    # delete the cookie that remembers the remember token 
    cookies.delete(:remember_token)
    # set the current user to nil
    self.current_user = nil
  end

end
