class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	#@user = User.new(params[:user]) is what we wish to do - but it is not dafe; so we do instead:
  	@user = User.new(user_params) # where user_params is defined below, taking care of the security issues - see Hartl tutorial
    if @user.save
    	flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'  # present the sign-up form again - with a list of errors
    end
  end

  def show
  	@user = User.find(params[:id]) # retrieves the record specified by the id parameter in the URL from the db and assigns it to @user
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation) # this places restrictions on what is acceptable in the passed params hatch
    end
end