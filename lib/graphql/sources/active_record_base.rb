# frozen_string_literal: true

module GraphQL
  module Sources
    # An abstract class for interacting with active record.
    class ActiveRecordBase < GraphQL::Dataloader::Source
      # @param model [Class] a child class of ActiveRecord::Base (e.g. Comment)
      # @param key [Symbol] an attribute (typically a foreign key) to use for loading (e.g. :user_id)
      # @return [Array] a key
      def self.batch_key_for(model, key: :id)
        return [model.to_sql, key] if model.is_a?(ActiveRecord::Relation)

        [model, key]
      end

      # @param model [Class] a child class of ActiveRecord::Base (e.g. Comment)
      # @param key [Symbol] an attribute (typically a foreign key) to use for loading (e.g. :user_id)
      def initialize(model, key: :id)
        super()
        @model = model
        @key = key
      end

      protected

      # @param keys [Array] an array of keys
      # @return [ActiveRecord_Relation] a collection of records
      def models(keys:)
        @model.where(@key => keys)
      end
    end
  end
end
