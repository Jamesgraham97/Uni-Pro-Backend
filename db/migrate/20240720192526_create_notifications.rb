# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :content
      t.boolean :read
      t.string :notification_type
      t.integer :friend_request_id

      t.timestamps
    end
  end
end
