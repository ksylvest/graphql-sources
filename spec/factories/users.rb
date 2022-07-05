# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |index| "User ##{index}" }

    trait :with_avatar do
      after :build do |user|
        io = File.open(File.join(__dir__, 'files/photo.png'))
        user.avatar.attach(io: io, filename: 'photo.png', content_type: 'image/png')
      end
    end

    trait :with_photos do
      after :build do |user|
        io = File.open(File.join(__dir__, 'files/photo.png'))
        user.photos.attach(io: io, filename: 'photo.png', content_type: 'image/png')
      end
    end
  end
end
