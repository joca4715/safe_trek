class CommentsController < ApplicationController
  before_action :authorize, only: [:create, :new, :destroy, :logout]
  before_action :find_commentable
  before_action :check_if_comment_belongs_to_current_user, only: [:destroy]

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new(comment_params) do |u|
      u.author = user_params
      u.user_id = user_identification
    end
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @user = current_user
    @comment = Comment.find(params[:comment_id])
    if @comment.user_id == @user.id
      @comment.comments.destroy_all
      @comment.destroy
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id)
  end

  def user_params
    current_user.name
  end

  def user_identification
    current_user.id
  end

  def find_commentable
    @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    @commentable = User.find_by_id(params[:user_id]) if params[:user_id]
    @commentable = Location.find_by_id(params[:location_id]) if params[:location_id]
  end

  def check_if_comment_belongs_to_current_user
    @user = current_user
    @comment = Comment.find(params[:comment_id])
    if @comment[:user_id] == @user.id
      true
    else
      false
    end
  end

end
