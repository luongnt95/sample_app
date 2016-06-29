module SessionsHelper
	def login user
		session[:user_id] = user.id
	end

	def logged_in?
		# can't be !@current_user.nil? because @variable just exists accross a controller
		!current_user.nil?
	end

	def current_user
		# In the same controller just need 1 sql query to find current_user even if use current_user multiple times
		# Don't need to check if session[:user_id] exists because it will if it doesn't, it will automatically return nil
		if user_id = session[:user_id]
			@current_user ||= User.find_by id: user_id
		elsif user_id = cookies.signed[:user_id]
			user = User.find_by id: user_id
			if user && user.cookie_authenticate(:auth, cookies.signed[:auth_token])
				login user
				@current_user = user
			end
		end
	end

	def current_user? user
		user == current_user
	end

	def forget_cookies user
		user.forget_auth_digest
		cookies.delete :user_id
		cookies.delete :auth_token
	end

	def logout
		# session.delete :user_id
		# reset the whole session
		# session is in cookies that was signed cryptically
		# cookies must be deleted first before session
		forget_cookies current_user
		reset_session
		@current_user = nil
	end

	def cookie_login user
		user.remember_auth_digest
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent.signed[:auth_token] = user.auth_token
	end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

end
