# frozen_string_literal: true

class CreateTeamProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :team_projects do |t|
      t.references :team, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
