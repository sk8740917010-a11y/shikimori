module LocaleConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
    # We removed the SEO indexing filter here
  end

  def set_locale
    I18n.locale = user_signed_in? ?
      (params[:locale].presence || current_user.locale).to_sym :
      I18n.default_locale
  end

  # We keep the method name but make it do absolutely nothing
  def ensure_only_russian_locale_indexed
  end
end