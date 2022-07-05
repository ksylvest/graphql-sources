# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_record/railtie'

Bundler.require(*Rails.groups)
require 'graphql/sources'

module Dummy
  class Application < Rails::Application
    config.eager_load = ENV['CI'].present?
    config.load_defaults Rails::VERSION::STRING.to_f
  end
end
