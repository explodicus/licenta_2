# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    # debugger
    if User.exists?(email: params[:user][:email])
      user = User.find_by(email: params[:user][:email])
      if user.admin_confirmed
        I18n.locale = user.locale
        super
      else
        flash[:primary] = 'An administrator is reviewing your application.'
        redirect_to new_user_session_path
      end
    else
      flash[:danger] = 'Invalid Email or password.'
      redirect_to new_user_session_path
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
