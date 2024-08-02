# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphQL::Sources::ActiveRecordExists do
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

    context 'without comments' do
      it 'loads falsey' do
        expect(result).to be_falsey
      end
    end

    context 'with comments' do
      before { create_pair(:comment, user: user) }

      it 'loads truthy' do
        expect(result).to be_truthy
      end
    end
  end
end
