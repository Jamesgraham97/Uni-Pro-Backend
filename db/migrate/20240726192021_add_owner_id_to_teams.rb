# frozen_string_literal: true

class AddOwnerIdToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :owner_id, :integer
  end
end
