ENV['REDIS_URL'] = 'redis://redis:6379/0'
ENV['REDIS_HOST'] = 'redis'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.