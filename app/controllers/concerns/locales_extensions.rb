require 'active_support/concern'

module LocalesExtensions
  extend ActiveSupport::Concern

  def set_locale!
    if language_change_necessary?
      I18n.locale = the_new_locale
      set_locale_cookie(I18n.locale)
    else
      use_locale_from_cookie
    end
  end

  def language_change_necessary?
    return cookies['locale'].nil? || params[:locale]
  end

  def the_new_locale
    new_locale = (params[:locale] || params[:lang] || extract_locale_from_accept_language_header)
    I18n.available_locales.map(&:to_s).include?(new_locale.to_s) ? new_locale : I18n.default_locale.to_s
  end

  # Sets the locale cookie
  def set_locale_cookie(locale)
    cookies['locale'] = locale.to_s
  end

  # Reads the locale cookie and sets the locale from it
  def use_locale_from_cookie
    I18n.locale = cookies['locale']
  end

  # Extracts the locale from the accept language header, if found
  def extract_locale_from_accept_language_header
    locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first rescue I18n.default_locale
  end
end
