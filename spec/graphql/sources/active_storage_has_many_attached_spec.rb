# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphQL::Sources::ActiveStorageHasManyAttached do
  describe '#fetch' do
    subject(:result) do
      GraphQL::Dataloader.with_dataloading do |dataloader|
        dataloader
          .with(described_class, :photos)
          .request(user)
          .load
      end
    end

    let!(:user) { create(:user, :with_photos) }

    it 'loads many attachments' do
      expect(result).to be_present
    end
  end
end
