# frozen_string_literal: true

class AddProfileFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :bio, :text
    add_column :users, :location, :string
    add_column :users, :profile_picture, :string
    add_column :users, :university, :string
    add_column :users, :github, :string
    add_column :users, :linkedin, :string
  end
end
