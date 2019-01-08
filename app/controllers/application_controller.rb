class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_locale

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    available_locales = I18n.available_locales.map(&:to_s)
    return parsed_locale if available_locales.include? parsed_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def hello
    render html: "hello, world!"
  end

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t :please_login
    redirect_to login_path
  end
end
