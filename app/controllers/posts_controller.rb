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
  private
  def post_params
    params.require(:post).permit(:body, :post_image)
  end
end
