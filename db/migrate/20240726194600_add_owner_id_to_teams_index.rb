# frozen_string_literal: true

class AddOwnerIdToTeamsIndex < ActiveRecord::Migration[7.1]
  def change
    add_index :teams, :owner_id
  end
end
