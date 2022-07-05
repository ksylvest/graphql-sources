# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphQL::Sources::ActiveStorageHasOneAttached do
  describe '#fetch' do
    subject(:result) do
      GraphQL::Dataloader.with_dataloading do |dataloader|
        dataloader
          .with(described_class, :avatar)
          .request(user)
          .load
      end
    end

    let!(:user) { create(:user, :with_avatar) }

    it 'loads one attachment' do
      expect(result).to be_present
    end
  end
end
