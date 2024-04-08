class PostsController < ApplicationController
  def index
    @posts = Post.all.order('created_at DESC')
  end
  def new
    @post = Post.new
  end
  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        format.html {redirect_to root_path, notice: "Post created successfully"}
      else
        format.html {render 'new', status: :unprocessable_entity}
      end
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.order('created_at DESC')
  end
  def edit
    @post = Post.find(params[:id])
  end
  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.update(post_params)
        format.html {redirect_to post_path, notice: "Post updated successfully!"}
      else
        format.html {render 'edit', status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path, notice: "Post deleted successfully!"
  end
  def like
    @post = Post.find(params[:id])
    unless @post.likers.exists?(current_user.id)
      @post_like = @post.post_likes.new(user_id: current_user.id)
      if @post_like.save
        render partial: "like_button", locals: { post: @post }
      else
        redirect_to root_path, alert: 'Unable to like this post.'
      end
    end
  end
  def dislike
    @post = Post.find(params[:id])
    @post_like = @post.post_likes.find_by(user_id: current_user.id)
    if @post_like && @post_like.destroy
      render partial: "like_button", locals: { post: @post }
    else
      redirect_to root_path, alert: 'Unable to dislike this post.'
    end
  end
  private
  def post_params
    params.require(:post).permit(:body, :post_image)
  end
end
