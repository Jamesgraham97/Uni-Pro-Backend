# frozen_string_literal: true

class UpdateProjectsAndTeams < ActiveRecord::Migration[7.1]
  def change
    # Add columns to projects
    add_column :projects, :given_date, :date
    add_column :projects, :due_date, :date
    add_column :projects, :grade, :string
    add_column :projects, :module_id, :integer

    # Remove columns from teams
    remove_column :teams, :given_date, :date
    remove_column :teams, :due_date, :date
    remove_column :teams, :description, :text
    remove_column :teams, :grade, :string
    remove_column :teams, :module_id, :integer
  end
end
