# frozen_string_literal: true

RSpec.describe GraphQL::Sources do
  it 'has a version number' do
    expect(GraphQL::Sources::VERSION).not_to be_nil
  end
end
