class Admin::BaseController < ActionController::Base

  include Typus::Authentication::const_get(Typus.authentication.to_s.classify)

  before_filter :set_models_constantized

  before_filter :reload_config_and_roles
  before_filter :authenticate
  before_filter :set_locale

  helper_method :current_user

  protected

  def reload_config_and_roles
    Typus.reload! unless Rails.env.production?
  end

  def set_path
    @back_to || request.referer || admin_dashboard_path
  end

  def set_locale
    I18n.locale = current_user.preferences[:locale]
  end

  def set_models_constantized
    if Typus::Configuration.models_constantized.nil?
      Typus::Configuration.models_constantized!
    end
  end

end
