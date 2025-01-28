# frozen_string_literal: true

module GraphQL
  module Sources
    # A class for loading `has_many_attached` style associations.
    #
    #   class User
    #     has_many_attached :photos
    #   end
    #
    #   class UserType < GraphQL::Schema::Object
    #     field :photos, [AttachedType], null: false
    #
    #     def photos
    #       dataloader
    #         .with(GraphQL::Sources::ActiveStorageHasManyAttached, :photos)
    #         .load(object)
    #     end
    #   end
    #
    # The resulting SQL query is:
    #
    #     SELECT "active_storage_attachments".*
    #     FROM "active_storage_attachments"
    #     WHERE "active_storage_attachments"."name" = 'photos'
    #       AND "active_storage_attachments"."record_type" = 'User'
    #       AND "active_storage_attachments"."record_id" IN (...)
    class ActiveStorageHasManyAttached < ActiveStorageBase
      # @param records [Array<ActiveRecord::Base>] an array of records
      # @return [Array] grouped attachments mirroring the keys
      def fetch(records)
        attachments = attachments(records: records)
        dataloader.yield

        map = attachments.group_by { |attachment| [attachment.record_type, attachment.record_id] }
        records.map { |record| map[[record.class.name, record.id]] || [] }
      end
    end
  end
end
