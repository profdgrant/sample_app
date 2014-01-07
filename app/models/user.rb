class User < ActiveRecord::Base

	# NOTE : The specification of the instance variables for this class is NOT done here! In Ruby, classes need not all be coded in one place.
	# It is through the definition of the database that the instance vars are ultimately generated.


# RAILS MEANS OF ADDING SECURE PASSWORD MECHANISM TO THE CLASS
	has_secure_password  # ensures virtual attributes for password and confirmation are added to the model; they are not database fields


# CALLBACKS FOR CREATION AND SAVING OF INSTANCES
	# before_save is a callback function in the parent class; it is called before saving to the database.
	# Here we set the code to convert the email to lowercase when the callback is invoked.
	before_save {email.downcase!}  # shorthand for explicit assignment of email attribute  

	before_create :create_remember_token # call-back, executed when the create method is called.

	# VALIDATIONS
	
	validates :name, presence: true, length: {maximum: 50 } # name must not be blank, and must not be more than 50 chars
	# this is equivalent to the method call validates(:name, presence: true)

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i  # specifies valid email address as a regular expression

	validates :email, 	presence: true, 
						format: {with: VALID_EMAIL_REGEX}, 
						uniqueness: { case_sensitive: false }

	validates :password, length: {minimum: 6}


# USEFUL CLASS METHODS
	def User.new_remember_token  # specifies a new class method that generates a random remember token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)  # specifies a new class method that encrypts a remember token
		Digest::SHA1.hexdigest(token.to_s) # fast encryption algorithm for a process that is executed on every page load
	end


# PRIVATE STUFF
	private
		def create_remember_token
			# generate a token, encrypt it, and assign it to the remember_token instance variable
			self.remember_token = User.encrypt(User.new_remember_token)
		end 

end
