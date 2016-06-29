class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # require_authenticate_user is so important that relate to security so it should be put on application_controller
  # to make sure that we don't miss to add before_filter to dangerous controller
  before_filter :require_authenticate_user

  include SessionsHelper

  private
	  def require_authenticate_user
	  	unless logged_in?
	  		flash[:danger] = "Please log in!"
	  		redirect_to login_url
	  	end
	  end
end
