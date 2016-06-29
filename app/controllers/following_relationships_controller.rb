class FollowingRelationshipsController < ApplicationController
	before_filter :correct_user, only: [:create]

	def create
		@user = User.find(params[:followed_id])
		current_user.follow(@user)
		# @relationship = current_user.find_relationship(@user.id)
		# current_user.follow params[:followed_id]
		respond_to do |format|
			format.html {redirect_to request.referrer || root_url}
			format.js
		end
	end

	def destroy
		# SQL Delete by composite id is faster than id :))) Don't know why?	
		# @user = User.find_by id: params[:id]
		# current_user.unfollow params[:id]
		@user = FollowingRelationship.find(params[:id]).followed
		current_user.unfollow(@user)
		respond_to do |format|
			format.html {redirect_to request.referrer || root_url}
			format.js
		end
	end

	private
		def correct_user; redirect_to root_url, flash: {warning: "No such user"} unless User.find_by(id: params[:followed_id]) end
end
