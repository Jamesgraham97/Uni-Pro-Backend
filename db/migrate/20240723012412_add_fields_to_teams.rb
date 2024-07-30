# frozen_string_literal: true

class AddFieldsToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :given_date, :date
    add_column :teams, :due_date, :date
    add_column :teams, :description, :text
    add_column :teams, :grade, :integer
    add_column :teams, :module_id, :integer
  end
end
