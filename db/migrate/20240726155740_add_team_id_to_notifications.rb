# frozen_string_literal: true

class AddTeamIdToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :team_id, :integer
  end
end
