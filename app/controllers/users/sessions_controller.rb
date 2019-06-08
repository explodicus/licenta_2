# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  def admin_new
    new
  end

  # POST /resource/sign_in
  def create
    if User.exists?(email: params[:user][:email])
      user = User.find_by(email: params[:user][:email])
      if params[:admin_sign_in] && user.admin?
        if user.valid_password?(params[:user][:password])
          I18n.locale = user.locale
          super
        else
          flash[:danger] = t('Invalid email or password')
          redirect_back(fallback_location: root_path)
        end
        return
      end
      if user.admin?
        flash[:primary] = t('Please use the admin login page')
        redirect_to new_user_session_path
        return
      end
      if user.admin_confirmed
        if user.valid_password?(params[:user][:password])
          I18n.locale = user.locale
        end
        super
      else
        flash[:primary] = t('An administrator is reviewing your application')
        redirect_to new_user_session_path
      end
      return
    else
      flash[:danger] = t('Invalid email or password')
      redirect_to new_user_session_path
      return
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
