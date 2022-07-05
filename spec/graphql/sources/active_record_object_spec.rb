# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphQL::Sources::ActiveRecordObject do
  describe '#fetch' do
    subject(:result) do
      GraphQL::Dataloader.with_dataloading do |dataloader|
        dataloader
          .with(described_class, Profile, key: :user_id)
          .request(user.id)
          .load
      end
    end

    let!(:user) { create(:user) }
    let!(:profile) { create(:profile, user: user) }

    it 'loads a record' do
      expect(result).to eql(profile)
    end
  end
end
