# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |index| "User ##{index}" }
  end
end
