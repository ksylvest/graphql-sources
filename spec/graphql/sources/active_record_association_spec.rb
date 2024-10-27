# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphQL::Sources::ActiveRecordAssociation do
  describe '#fetch' do
    subject(:result) do
      GraphQL::Dataloader.with_dataloading do |dataloader|
        dataloader
          .with(described_class, :comments)
          .request(user)
          .load
      end
    end

    let!(:user) { create(:user) }
    let!(:comments) { create_pair(:comment, user: user) }

    it 'loads many records' do
      expect(result).to match_array(comments)
    end
  end
end
