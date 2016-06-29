class SessionsController < ApplicationController
	skip_before_filter :require_authenticate_user
	# You can only log in when you logged out
	before_filter :require_logged_out_user, only: [:new, :create]

	def new
	end

	def create
		@user = User.find_by email: params[:session][:email].downcase
		if @user && @user.authenticate(params[:session][:password])
			login @user
			cookie_login @user if params[:session][:remember_me] == "1"
			redirect_to root_url, flash: {success: "Welcome to the Sample App!"}
		else
			flash.now[:warning] = "Your email or password is wrong!"
			render 'new'
		end
	end

	def destroy
		if logged_in?
			logout
			flash[:success] = "Good bye!"
		end
		redirect_to root_url
	end

	private
		def require_logged_out_user; redirect_to root_url, flash: {warning: "You have logged in!"} if logged_in? end
end
