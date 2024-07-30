# frozen_string_literal: true

class CreateWhiteboards < ActiveRecord::Migration[7.1]
  def change
    create_table :whiteboards do |t|
      t.string :title
      t.text :content
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
