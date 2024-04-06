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

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
