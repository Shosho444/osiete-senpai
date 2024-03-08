class LikesController < ApplicationController
  before_action :set_like, only: %i[destroy]

  # POST /likes or /likes.json
  def create
    @like = Like.new(like_params)
    @like.save
    @likes = Like.where(likeable_id: @like.likeable_id, likeable_type: @like.likeable_type)
  end

  # DELETE /likes/1 or /likes/1.json
  def destroy
    @like.destroy!
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type).merge(user_id: current_user.id)
  end
end
