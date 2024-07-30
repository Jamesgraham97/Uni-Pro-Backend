# frozen_string_literal: true

class ChangePriorityToString < ActiveRecord::Migration[7.1]
  def up
    change_column :project_assignments, :priority, :string, null: false
    change_column :assignments, :priority, :string
  end

  def down
    change_column :project_assignments, :priority, :integer, null: false
    change_column :assignments, :priority, :integer
  end
end
