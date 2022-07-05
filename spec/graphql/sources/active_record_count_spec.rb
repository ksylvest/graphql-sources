# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphQL::Sources::ActiveRecordCount do
  describe '#fetch' do
    subject(:result) do
      GraphQL::Dataloader.with_dataloading do |dataloader|
        dataloader
          .with(described_class, Comment, key: :user_id)
          .request(user.id)
          .load
      end
    end

    let!(:user) { create(:user) }
    let!(:comments) { create_pair(:comment, user: user) }

    it 'loads a count' do
      expect(result).to eql(comments.count)
    end
  end
end
