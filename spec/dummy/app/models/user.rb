# frozen_string_literal: true

class User < ApplicationRecord
  has_one :profile
  has_one_attached :avatar
  has_many_attached :photos
end
