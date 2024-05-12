class CreateSubtasks < ActiveRecord::Migration[7.1]
  def change
    create_table :subtasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.integer :priority
      t.references :assignment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
