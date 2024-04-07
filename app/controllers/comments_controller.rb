class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html {redirect_to @post, notice: "Comment created successfully"}
      else
        format.html {render 'posts/show', status: :unprocessable_entity}
      end
    end
  end
  def edit
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
  end
  def update
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.html {redirect_to @post, notice: "Comment updated successfully"}
      else
        format.html {render 'edit', status: :unprocessable_entity}
      end
    end
  end
  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to @post, notice: "Comment deleted successfully"
  end
  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
