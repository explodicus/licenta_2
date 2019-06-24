class ChildrenController < ApplicationController
  after_action :verify_authorized

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    @user.parent = current_user
    @user.email = nil
    @user.phone_number = current_user.phone_number
    @user.preferred_language = current_user.preferred_language
    authorize @user
    if @user.save
      current_user.become_parent
      redirect_to root_url
    else
      render 'new'
    end
  end

  def new_full
    @user = User.find(params[:id])
    authorize @user
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    unless current_user.valid_password?(params[:current_password])
      flash[:danger] = t('Wrong password')
      render 'edit'
      return
    end
    if @user.update_attributes(user_params)
      flash[:success] = t('Child account updated')
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create_full
    @user = User.find(params[:id])
    authorize @user
    unless current_user.valid_password?(params[:current_password])
      flash[:danger] = t('Wrong password')
      render 'new_full'
      return
    end
    @user.parent_id = nil
    if @user.update_attributes(user_params_full)
      flash[:success] = t('Full account created To start using it, please follow the instructions sent to your email')
      @user.save
      redirect_to root_url
    else
      render 'new_full'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :date_of_birth)
  end

  def user_params_full
    params.require(:user).permit(:first_name, :last_name, :date_of_birth, :email, :password, :phone_number, :password_confirmation)
  end
end
