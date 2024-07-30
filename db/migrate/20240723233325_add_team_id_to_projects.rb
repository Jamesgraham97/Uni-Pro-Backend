# frozen_string_literal: true

class AddTeamIdToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :team_id, :integer
  end
end
