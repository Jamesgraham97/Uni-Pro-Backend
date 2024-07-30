# frozen_string_literal: true

class AddProjectToAssignments < ActiveRecord::Migration[7.1]
  def change
    add_reference :assignments, :project, foreign_key: true
  end
end
