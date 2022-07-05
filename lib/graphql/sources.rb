# frozen_string_literal: true

require 'graphql'

require_relative './sources/active_record_count'
require_relative './sources/active_record_collection'
require_relative './sources/active_record_object'
require_relative './sources/active_storage_has_many_attached'
require_relative './sources/active_storage_has_one_attached'

module GraphQL
  # A collection of common GraphQL dataloader classes.
  module Sources
  end
end
