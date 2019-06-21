class UsersController < ApplicationController
  before_action :set_user, except: %i[index students teachers pending_approval]
  after_action :verify_authorized

  def show
    authorize @user
  end

  def students
    @users = User.with_role(:student)
    authorize @users
  end

  def teachers
    @users = User.with_role(:teacher)
    authorize @users
  end

  def pending_approval
    @users = User.where('admin_confirmed = false AND (confirmed_at IS NOT NULL OR parent_id IS NOT NULL)')
    authorize @users
  end

  def make_admin
    authorize @user
    @user.become_admin
    redirect_to @user
  end

  def make_teacher
    authorize @user
    @user.become_teacher
    redirect_to @user
  end

  def make_editor
    authorize @user
    @user.add_role :editor
    redirect_to @user
  end

  def remove_admin
    authorize @user
    @user.remove_role :admin
    redirect_to @user
  end

  def remove_teacher
    authorize @user
    @user.remove_role :teacher
    redirect_to @user
  end

  def remove_editor
    authorize @user
    @user.remove_role :editor
    redirect_to @user
  end

  def timetable
    authorize @user
  end

  def approve
    authorize @user
    @user.admin_confirmed = true
    @user.become_student
    @user.save
    if (@user.child?)
      UserMailer.child_account_confirmation(@user.parent).deliver_now
    else
      UserMailer.account_confirmation(@user).deliver_now
    end
    flash[:success] = t('The user was accepted')
    redirect_to pending_approval_users_path
  end

  def reject
    authorize @user
    @user.destroy
    flash[:success] = t('The user was rejected')
    redirect_to pending_approval_users_path
  end

  def set_discount
    authorize @user
  end

  def update_discount
    authorize @user
    if params[:user][:discount] == '' || params[:user][:discount].to_i > 100
      flash[:danger] = t('Discount has to be a percentage')
      render 'set_discount'
    else
      @user.discount = params[:user][:discount].to_f / 100
      @user.save
      flash[:success] = t('User updated')
      redirect_to @user
    end
  end

  def sign_sb_in
    authorize @user
    sign_in @user
    redirect_to root_path
  end

  private

  def group_params
    params.require(:user).permit(:discount)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
