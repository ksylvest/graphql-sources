# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :comments do |t|
    t.integer :user_id, null: false, index: true
    t.string :message, null: false
  end

  create_table :profiles do |t|
    t.integer :user_id, null: false, index: true
    t.string :url, null: false
  end

  create_table :users do |t|
    t.string :name, null: false
  end

  add_foreign_key :comments, :users
  add_foreign_key :profiles, :users
end
