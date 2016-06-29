class UsersController < ApplicationController
  before_filter :require_authenticate_user, except: [:new, :create]
  # ensure if user exists with these actions that need id
  before_filter :ensure_user, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :require_admin_user, only: [:destroy]

  def index
    load_users
  end

  def show
    load_user
    @microposts = @user.find_recent_microposts
    # @relationship = FollowingRelationship.new unless @relationship = current_user.find_relationship(@user.id)
    # Can't use @following_relationship = FollowingRelationship.new or current_user.following_relationships.find_by followed_id: @user.id 
    # because this show page show both follow and unfollow form 
  end

  def new
    build_user
  end

  def create
    build_user
    if @user.save
      login @user
      redirect_to root_url, flash: {success: "Welcome to the Sample App!"}
    else
      render 'new'
    end
  end

  def edit
    build_user
  end

  # We can't use current_user to update or edit because We have admin who can edit or update any user other than himself
  # so we must use user instead
  def update
    load_user
    if @user.update_attributes user_params
      redirect_to root_url, flash: {success: "Update successfully!"}
    else
      render 'edit'
    end
  end

  def destroy
    load_user
    @user.destroy
    redirect_to root_url, flash: {success: "You have deleted  \"#{@user.name}\""}
  end

  private
    # security: prevent massive-assign includes important infomation
    def user_params
      user_params = params[:user]
      user_params ? user_params.permit(:name, :email, :password, :password_confirmation) : {}
    end
    
    def load_users; @users ||= User.all end

    def load_user; @user ||= User.find_by id: params[:id] end

    def build_user; @user = User.new user_params end
    
    def ensure_user; redirect_to users_url, flash: {warning: "No such user"} unless load_user end

    def correct_user; redirect_to root_url, flash: {danger: "Permission denied!"} unless current_user? load_user end

    def require_admin_user; redirect_to root_url, flash: {danger: "Permission denied!"} unless current_user.admin? end
end
