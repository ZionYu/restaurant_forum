class FollowshipsController < ApplicationController
  def create
    @followship = Followship.new(user_id: current_user.id, following_id: params[:following_id])
    
      if @followship.save
        flash[:notice] = "Successfully followed"
        redirect_back(fallback_location: root_path)
      else
        flash[:alert] = @followship.errors.full_messages.to_sentence
        redirect_back(fallback_location: root_path)
      end 
  end
end
