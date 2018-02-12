class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: [:destroy]
	def create
		@micropost = current_user.micropost.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost Created"
			redirect_to root_url
		else
			@feed_items = []
			#flash[:danger] = "Content can't blank!!!"
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.delete
		flash[:success] = "Micropost Deleted!!"
		redirect_to request.referrer || root_url
	end

	private 

	def micropost_params
		params.require(:micropost).permit(:content, :picture)
    end

	def correct_user
		@micropost = current_user.micropost.find_by(id: params[:id])
		redirect_to root_url if @micropost.nil?
	end
end
