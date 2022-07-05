# frozen_string_literal: true

module GraphQL
  module Sources
    # A class for loading with Rails.cache.
    #
    #   class UserType < GraphQL::Schema::Object
    #     field :location, String, null: false
    #
    #     def location
    #       dataloader
    #         .with(GraphQL::Sources::RailsCache)
    #         .load(key: "geocode:#{object.latest_ip}", fallback: -> { Geocode.for(object.latest_ip) })
    #     end
    #   end
    class RailsCache < GraphQL::Dataloader::Source
      # @param operations [Array<Hash>] an array of key and fallback hashes
      def fetch(operations)
        keys = operations.pluck(:key)
        fallbacks = operations.to_h { |operation| [operation[:key], operation[:fallback]] }
        results = Rails.cache.fetch_multi(*keys) { |key| fallbacks[key].call }
        keys.map { |key| results[key] }
      end
    end
  end
end
