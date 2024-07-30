# frozen_string_literal: true

class DropTeamProjectsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :team_projects
  end
end
