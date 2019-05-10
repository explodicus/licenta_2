class GroupsController < ApplicationController
  before_action :set_group, except: %i[index new create]
  after_action :verify_authorized

  def index
    @groups = Group.all
    authorize @groups
  end

  def show
    authorize @group
    @lesson = @group.lessons.build
  end

  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = Group.new(group_params)
    authorize @group
    @group.active = true
    if @group.save
      params[:group][:users].each do |user|
        unless user.empty?
          @group.users << User.find(user)
          Relationship.find_by(user_id: user, group_id: @group.id).set_color
        end
      end
      flash[:success] = 'Group was successfully created'
      redirect_to @group
    else
      render 'new'
    end
  end

  def edit
    authorize @group
  end

  def update
    authorize @group
    if @group.update_attributes(group_params)
      i = 1
      until params[:group][:users][i].empty?
        Relationship.find_by(user_id: params[:group][:users][i], group_id: @group.id).destroy
        i += 1
      end
      i += 1
      until params[:group][:users][i].empty?
        @group.users << User.find(params[:group][:users][i])
        if Group.find(@group_id).active
          Relationship.find_by(user_id: params[:group][:users][i], group_id: @group.id).set_color
        end
        i += 1
      end
      i += 1
      until params[:group][:users][i].empty?
        Relationship.find_by(user_id: params[:group][:users][i], group_id: @group.id).destroy
        i += 1
      end
      i += 1
      while i < params[:group][:users].size
        @group.users << User.find(params[:group][:users][i])
        if Group.find(@group_id).active
          Relationship.find_by(user_id: params[:group][:users][i], group_id: @group.id).set_color
        end
        i += 1
      end
      flash[:success] = t('Group updated')
      redirect_to @group
    else
      render 'edit'
    end
  end

  def destroy
    @group.destroy
    authorize @group
    flash[:success] = 'Group deleted'
    redirect_to groups_url
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :kind, :price, :active, :notes, :expiration_date)
  end

end
