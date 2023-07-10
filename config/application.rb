require_relative "boot"
require "rails"

# SEE: https://github.com/rails/rails/blob/6-0-stable/railties/lib/rails/all.rb
# require 'rails/all'

require "active_record/railtie"
# require 'active_storage/engine'
require "action_controller/railtie"
require "action_view/railtie"
# require 'action_mailer/railtie'
require "active_job/railtie"
# require 'action_cable/engine'
# require 'action_mailbox/engine'
# require 'action_text/engine'
require "rails/test_unit/railtie"
# require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Feeder
  class Application < Rails::Application
    config.load_defaults 7.0
    config.autoload_paths += %w[app lib].map { |path| config.root.join(path) }
    config.add_autoload_paths_to_load_path = false
    config.active_support.cache_format_version = 6.1

    config.hosts << "feeder.local"
    config.hosts << "frf.im"
    config.hosts << "localhost"
    config.hosts << "app"

    config.generators do |generate|
      generate.test_framework :rspec, fixture: false
      generate.controller_specs true
      generate.decorator false
      generate.helper false
      generate.helper_specs false
      generate.javascripts false
      generate.routing_specs false
      generate.skip_routes true
      generate.stylesheets false
      generate.view_specs false
    end
  end
end
