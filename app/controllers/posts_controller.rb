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

  private
  def post_params
    params.require(:post).permit(:body, :post_image)
  end
end
