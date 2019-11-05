require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Artistine
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.timezone = 'Brussels'
    
    config.generators do |g|
      g.test_framework  :rspec, fixture: false
      g.view_specs      false
      g.helper_specs    false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators.system_tests = nil

    config.i18n.default_locale = :nl
  end
end
