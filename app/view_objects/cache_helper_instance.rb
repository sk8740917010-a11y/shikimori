class CacheHelperInstance
  include Singleton
  include Draper::ViewHelpers

  def self.cache_keys(*args)
    instance.cache_keys(*args)
  end

  def request_domain
    h.request.domain
  end

  def cache_keys(*args)
    args
      # do not replace with filter_map since filter_map excludes "false" values
      .map do |v|
        if v.respond_to?(:cache_key_with_version)
          v.cache_key_with_version
        elsif v.respond_to?(:cache_key)
          v.cache_key
        else
          v
        end
      end.compact + [
        I18n.locale,
        request_domain
      ]
  end
end
