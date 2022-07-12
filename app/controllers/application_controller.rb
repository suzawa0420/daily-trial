class ApplicationController < ActionController::Base
  before_action :set_locale


  def current_user
    ActiveDecorator::Decorator.instance.decorate(super) if super.present?
    super
  end

  # これは自動で実行される
  def default_url_options
    { locale: I18n.locale }
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end
