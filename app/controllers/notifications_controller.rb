class NotificationsController < ApplicationController
  before_action :set_notification, except: %i[new create]
  after_action :verify_authorized

  def show
    authorize @notification
    @notification.read = true
    @notification.save
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
