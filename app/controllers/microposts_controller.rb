class MicropostsController < ApplicationController
	before_filter :require_authenticate_user, only: [:create, :destroy]
	# ensure_micropost filter must be above correct_user in order to check if micropost exists?
	before_filter :ensure_micropost, only: [:destroy]
	before_filter :correct_user, only: [:destroy]

  def index
    @microposts = Micropost.order_by_created_at_in_desc
  end

  def create
  	@micropost = current_user.microposts.build micropost_params
    if @micropost.save
  		redirect_to root_url, flash: {success: "Micropost created!"} 
  	else
  		render 'static_pages/home'
  	end
  end

  def destroy
    load_micropost
  	@micropost.destroy
  	redirect_to user_url(current_user), flash: {success: "Micropost deleted!"}
  end

  private
  	def micropost_params; params.require(:micropost).permit(:content) end

  	def load_micropost; @micropost ||= Micropost.find_by id: params[:id] end

  	def ensure_micropost; redirect_to root_url, flash: {warning: "No such micropost!"} unless load_micropost end

  	# if micropost is nil then micropost.user would cause error
  	def correct_user; redirect_to root_url, flash: {success: "Permission denied!"} unless current_user? load_micropost.user end
end