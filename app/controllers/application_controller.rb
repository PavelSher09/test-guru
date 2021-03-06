class ApplicationController < ActionController::Base

  before_action :set_locale

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_not_found

  def default_url_options
    { lang: (I18n.locale unless I18n.locale == I18n.default_locale) }
  end

  protected

  def after_sign_in_path_for(user)
    if user.class == Admin
      admin_tests_path 
    elsif user.class == User
      root_path 
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  private

  def set_locale
    I18n.locale = I18n.locale_available?(params[:lang]) ? params[:lang] : I18n.default_locale
  end

end