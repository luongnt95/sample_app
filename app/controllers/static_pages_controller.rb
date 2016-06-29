class StaticPagesController < ApplicationController
  skip_before_filter :require_authenticate_user
  
  def home
  	# Don't need to use current_user.microposts.build because when @micropost is posted to server the params just get 'content attribute'
  	# also current_user.microposts.build micropost_params will change user_id in micropost into the id of current_user
  	# current_user.microposts.build is ok here but We use current_user.microposts.size in the view so it's value will increment 1 because
  	# current_user.microposts.build create a new micropost object references to current_user 
  	if logged_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed
    end
  end

  def help
  end

  def contact
  end

  def about
  end
end