# frozen_string_literal: true

require 'graphql'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.push_dir(__dir__, namespace: GraphQL)
loader.setup

module GraphQL
  # A collection of common GraphQL dataloader classes.
  module Sources
  end
end
