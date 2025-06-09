# frozen_string_literal: true

class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :avatar
  has_many_attached :photos
end
