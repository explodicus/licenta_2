class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:last_name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:date_of_birth])
    devise_parameter_sanitizer.permit(:account_update, keys: [:date_of_birth])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:discount])
    devise_parameter_sanitizer.permit(:account_update, keys: [:discount])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:preferred_language])
    devise_parameter_sanitizer.permit(:account_update, keys: [:preferred_language])
  end

  def set_locale
    I18n.locale = params[:locale] || extract_locale_from_accept_language_header
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private
  def extract_locale_from_accept_language_header
    parsed_locale = params[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/)[0]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : I18n.default_locale
  end

  def user_not_authorized
    flash[:alert] = t("You don't seem to have access to view this page Please log in as a different user to see it")
    redirect_to root_path
  end
end
