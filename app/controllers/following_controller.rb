class FollowingController < ApplicationController
	def index
		load_user
		@users = @user.following
	end

	private
		def load_user; @user ||= User.find_by(id: params[:user_id]) end
end