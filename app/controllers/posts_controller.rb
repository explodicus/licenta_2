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
      user_ids = Set.new
      if params[:groups]
        params[:groups].each do |group_id|
          Group.find(group_id).users.each do |user|
            if user.child?
              user_ids.add(user.parent.id)
            else
              user_ids.add(user.id)
            end
          end
        end
        user_ids.each do |user_id|
          user = User.find(user_id)
          if user.preferred_language == 'Romanian'
            @notification = user.notifications.build(title: "Postare nouă: #{@post.title}", content: @post.id.to_s, read: false)
            @notification.save
          elsif user.preferred_language == 'English'
            @notification = user.notifications.build(title: "New post: #{@post.title}", content: @post.id.to_s, read: false)
            @notification.save
          elsif user.preferred_language == 'Russian'
            @notification = user.notifications.build(title: "Новый пост: #{@post.title}", content: @post.id.to_s, read: false)
            @notification.save

          end
        end
      end
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
      flash[:success] = t('Post updated')
      redirect_to @post
    end
  end

  def destroy
    @post.destroy
    authorize @post
    flash[:success] = t('Post deleted')
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
