# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_record/railtie'
require 'active_storage/engine'

Bundler.require(*Rails.groups)
require 'graphql/sources'

module Dummy
  class Application < Rails::Application
    config.eager_load = ENV['CI'].present?
    config.load_defaults Float("#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}")
    config.active_storage.service = :local
  end
end
