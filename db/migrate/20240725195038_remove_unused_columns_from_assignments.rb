# frozen_string_literal: true

class RemoveUnusedColumnsFromAssignments < ActiveRecord::Migration[7.1]
  def change
    remove_reference :assignments, :project, foreign_key: true
    remove_column :assignments, :parent_id, :integer
    drop_table :collaborations
  end
end
