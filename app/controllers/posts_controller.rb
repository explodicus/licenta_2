class PostsController < ApplicationController
  before_action :set_post, except: %i[index new create]
  after_action :verify_authorized

  def index
    @posts = Post.paginate(page: params[:page])
    authorize @posts
  end

  def show
    authorize @post
  end

  def new
    @post = Post.new
    authorize @post
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize @post
    if @post.save
      flash[:success] = t('Post was successfully created')
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
    authorize @post
  end

  def update
    authorize @post
    if @post.update_attributes(post_params)
      flash[:success] = 'Post updated'
      redirect_to @post
    end
  end

  def destroy
    @post.destroy
    authorize @post
    flash[:success] = 'Post deleted'
    redirect_to posts_url
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :short_content, :image)
  end
end
