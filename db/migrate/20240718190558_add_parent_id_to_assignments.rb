# frozen_string_literal: true

class AddParentIdToAssignments < ActiveRecord::Migration[7.1]
  def change
    add_column :assignments, :parent_id, :integer
  end
end
