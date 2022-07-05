# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphQL::Sources::RailsCache do
  describe '#fetch' do
    subject(:result) do
      GraphQL::Dataloader.with_dataloading do |dataloader|
        dataloader
          .with(described_class)
          .request(key: 'key', fallback: -> { 'value' })
          .load
      end
    end

    it 'loads cache' do
      expect(result).to eql('value')
    end
  end
end
