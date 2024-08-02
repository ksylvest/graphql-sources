# frozen_string_literal: true

module GraphQL
  module Sources
    # A class for checking existence of records.
    #
    #   class Post
    #     has_many :likes
    #   end
    #
    #   class Like
    #     belongs_to :post
    #   end
    #
    #   class PostType < GraphQL::Schema::Object
    #     field :likes, Integer, null: false
    #
    #     def likes
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordExists, ::Like, key: :post_id)
    #         .load(object.id)
    #     end
    #   end
    #
    # The resulting SQL query is:
    #
    #     SELECT "likes"."post_id"
    #     FROM "likes"
    #     WHERE "likes"."post_id" IN (1, 2, 3, ...)
    #     GROUP BY "likes"."post_id"
    class ActiveRecordExists < ActiveRecordBase
      # @param keys [Array] an array of keys
      # @return [Array<Boolean>] an array of booleans
      def fetch(keys)
        set = Set.new(models(keys: keys).group(@key).pluck(@key))
        keys.map { |key| set.member?(key) }
      end
    end
  end
end
