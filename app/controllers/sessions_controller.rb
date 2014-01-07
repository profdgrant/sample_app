class SessionsController < ApplicationController
	
	def new
	end

	def create
  user = User.find_by(email: params[:session][:email].downcase)  # find the user corresponding to submitted email in the database
  if user && user.authenticate(params[:session][:password]) # check that there IS such a user, and then, if there is, that the passowrd is correct
    # Sign the user in and redirect to the user's show page
    sign_in user # remember - this is really sign_in(user) for those of us who are traditionalists! method is in sessions_helper.rb
    redirect_to user

  else
    # Create an error message and re-render the signin form.
    flash.now[:error] = 'Invalid email/password combination' #flash.now displays flash on teh rendered page (& so not on the next page to be displayed)
    render 'new'
  end
end

	def destroy
		sign_out
		redirect_to root_url
	end

end
