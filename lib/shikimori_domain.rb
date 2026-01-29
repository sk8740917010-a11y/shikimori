module ShikimoriDomain
  FOREVER_BANNED_HOST = 'shikimori.org'
  OLD_HOST = 'shikimori.me'
  NEW_HOST = 'shikimori.one'

  # We include localhost and 127.0.0.1 to ensure Docker and 
  # local browsers can both talk to the app.
  HOSTS = [NEW_HOST, OLD_HOST, FOREVER_BANNED_HOST] + (
    Rails.env.development? ? %w[shikimori.local shiki.local localhost 127.0.0.1 0.0.0.0] : []
  )

  BANNED_HOSTS = [FOREVER_BANNED_HOST, OLD_HOST]

  # PROPER_HOST is used by the app to build absolute URLs.
  # We set it to localhost for development.
  PROPER_HOST = Rails.env.production? ? NEW_HOST : 'localhost'

  def self.matches?(request)
    # This check is used by Rails routes to allow/deny access.
    HOSTS.include?(request.host)
  end
end