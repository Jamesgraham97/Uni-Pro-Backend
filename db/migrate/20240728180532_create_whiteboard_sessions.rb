# frozen_string_literal: true

class CreateWhiteboardSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :whiteboard_sessions do |t|
      t.string :title
      t.text :content
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
