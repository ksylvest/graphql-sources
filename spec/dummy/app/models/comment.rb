# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  validates :message, presence: true
end
