class CommentsController < ApplicationController
  
  #make sure only the admin deletes comments.
  before_filter :authenticate, :only => :destroy
  
  def index
    @comments = Comment.all
  end
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(params[:comment])
    redirect_to post_path(@post)
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end

end
