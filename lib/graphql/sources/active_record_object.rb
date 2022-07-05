# frozen_string_literal: true

require_relative './active_record_base'

module GraphQL
  module Sources
    # A class for loading `has_one` style associations.
    #
    #   class User
    #     has_one :profile
    #   end
    #
    #   class Profile
    #     belongs_to :user
    #   end
    #
    #   class UserType < GraphQL::Schema::Object
    #     field :profile, [ProfileType], null: false
    #
    #     def profile
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordCollection, ::Profile, key: :user_id)
    #         .load(object.id)
    #     end
    #   end
    #
    # The resulting SQL query is:
    #
    #     SELECT "profiles".*
    #     FROM "profiles"
    #     WHERE "profiles"."user_id" IN (1, 2, 3, ...)
    #     ORDER BY "profiles"."id"
    class ActiveRecordObject < ActiveRecordBase
      def fetch(keys)
        models = models(keys: keys).order(:id).load_async
        dataloader.yield

        map = models.index_by { |model| model[@key] }
        keys.map { |key| map[key] }
      end
    end
  end
end
