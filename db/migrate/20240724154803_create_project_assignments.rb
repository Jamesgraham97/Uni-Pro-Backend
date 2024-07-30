# frozen_string_literal: true

class CreateProjectAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :project_assignments do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :status, null: false
      t.integer :priority, null: false
      t.references :project, null: false, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
