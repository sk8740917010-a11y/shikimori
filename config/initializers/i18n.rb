require 'i18n-js'

module I18n::RussianCheck
  def russian?
    I18n.locale == :ru
  end
end

I18n.extend(I18n::RussianCheck)

if defined?(I18n::JS)
  I18n::JS.config do |config|
    config.export_i18n_js_dir_path =
      Rails.root.join('app', 'packs', 'javascripts', 'i18n')

    config.available_locales = [:en, :ru]
  end
end
