# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    user
    url { 'https://ksylvest.com' }
  end
end
