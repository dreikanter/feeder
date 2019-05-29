require_relative 'boot'
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Feeder
  class Application < Rails::Application
    config.autoload_paths += %w(app lib).map { |p| Rails.root.join p }

    config.active_job.queue_adapter = :delayed_job

    config.eager_load = true

    # config.action_cable.mount_path = '/cable'

    config.generators do |g|
      g.test_framework :minitest, spec: false, fixture: false
      g.helper       false
      g.decorator    false
      g.assets       false
      g.stylesheets  false
      g.javascripts  false
      g.view_specs   false
      g.helper_specs false
      g.skip_routes  true
    end

    config.lograge.enabled = true
    config.lograge.custom_options = lambda do |event|
      params = event.payload[:params].except('controller', 'action')
      { params: params } unless params.empty?
    end

    # Turn off Rails Asset Pipeline
    config.assets.enabled = false

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get post put patch options]
      end
    end
  end
end
