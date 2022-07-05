# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  validates :url, presence: true
end
