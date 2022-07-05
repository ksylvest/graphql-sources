# frozen_string_literal: true

require_relative './active_record_base'

module GraphQL
  module Sources
    # A class for loading `has_many` style associations.
    #
    #   class User
    #     has_many :comments
    #   end
    #
    #   class Comment
    #     belongs_to :user
    #   end
    #
    #   class UserType < GraphQL::Schema::Object
    #     field :comments, [CommentType], null: false
    #
    #     def comments
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordCollection, ::Comment, key: :user_id)
    #         .load(object.id)
    #     end
    #   end
    #
    # The resulting SQL query is:
    #
    #     SELECT "comments".*
    #     FROM "comments"
    #     WHERE "comments"."user_id" IN (...)
    #     ORDER BY "comments"."id"
    class ActiveRecordCollection < ActiveRecordBase
      def fetch(keys)
        models = models(keys: keys).order(:id).load_async
        dataloader.yield

        map = models.group_by { |model| model[@key] }
        keys.map { |key| map[key] || [] }
      end
    end
  end
end
