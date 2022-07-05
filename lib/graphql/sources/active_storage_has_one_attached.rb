# frozen_string_literal: true

require_relative './active_storage_base'

module GraphQL
  module Sources
    # A class for loading `has_one_attached` style associations.
    #
    #   class User
    #     has_one_attached :photo
    #   end
    #
    #   class UserType < GraphQL::Schema::Object
    #     field :avatar, AttachedType, null: false
    #
    #     def avatar
    #       dataloader
    #         .with(GraphQL::Sources::ActiveStorageHasOneAttached, :avatar)
    #         .load(object)
    #     end
    #   end
    #
    # The resulting SQL query is:
    #
    #     SELECT "active_storage_attachments".*
    #     FROM "active_storage_attachments"
    #     WHERE "active_storage_attachments"."name" = 'avatar'
    #       AND "active_storage_attachments"."record_type" = 'User'
    #       AND "active_storage_attachments"."record_id" IN (...)
    class ActiveStorageHasOneAttached < ActiveStorageBase
      def fetch(records)
        attachments = attachments(records: records).load_async
        dataloader.yield

        map = attachments.index_by { |attachment| [attachment.record_type, attachment.record_id] }
        records.map { |record| map[[record.class.name, record.id]] }
      end
    end
  end
end
