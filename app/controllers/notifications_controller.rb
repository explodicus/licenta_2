class NotificationsController < ApplicationController
  before_action :set_notification, except: %i[new create]
  after_action :verify_authorized

  def show
    authorize @notification
    @notification.read = true
    @notification.save
    if @notification.title.include?('New post: ') || @notification.title.include?('Postare nouă: ') || @notification.title.include?('Новый пост: ')
      if Post.exists?(@notification.content.to_i)
        redirect_to Post.find(@notification.content.to_i)
      else
        @notification.destroy
        redirect_to root_path
      end
    end
  end

  def new
    @notification = Notification.new
    authorize @notification
  end

  def create
    group = Group.find(params[:group_id])
    group.users.each do |user|
      @notification = user.notifications.build(notification_params)
      authorize @notification
      @notification.read = false
      unless @notification.save
        render 'new'
        return
      end
    end
    flash[:success] = t('Message was successfully sent')
    redirect_to root_path
  end

  private

  def notification_params
    params.require(:notification).permit(:title, :content)
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
