# frozen_string_literal: true

module GraphQL
  module Sources
    # A class for loading a count of records.
    #
    #   class User
    #     has_many :purchases
    #   end
    #
    #   class Product
    #     has_many :purchases
    #   end
    #
    #   class Purchase
    #     belongs_to :product
    #     belongs_to :user
    #   end
    #
    #   class ProductType < GraphQL::Schema::Object
    #     field :purchased, Boolean, null: false
    #
    #     def purchased
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordCount, ::Purchase.where(user: context.user), key: :product_id)
    #         .load(object.id)
    #     end
    #   end
    #
    # The resulting SQL query is:
    #
    #     SELECT "purchases"."post_id", COUNT(*)
    #     FROM "purchases"
    #     WHERE "purchases"."user_id" = ... AND "purchases"."product_id" IN (1, 2, 3, ...)
    #     GROUP BY "purchases"."post_id"
    class ActiveRecordCount < ActiveRecordBase
      # @param keys [Array] an array of keys
      # @return [Array] grouped counts for the keys
      def fetch(keys)
        map = models(keys: keys).group(@key).count
        keys.map { |key| map[key] || 0 }
      end
    end
  end
end
