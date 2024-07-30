# frozen_string_literal: true

class AddColorToModules < ActiveRecord::Migration[7.1]
  def change
    add_column :course_modules, :color, :string, default: '#ffffff'
  end
end
