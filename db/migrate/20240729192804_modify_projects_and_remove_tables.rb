class ModifyProjectsAndRemoveTables < ActiveRecord::Migration[7.1]
  def change
    # Change grade to grade_weight in projects table
    rename_column :projects, :grade, :grade_weight
    change_column :projects, :grade_weight, 'integer USING CAST(grade_weight AS integer)'

    # Drop unnecessary tables
    drop_table :comments do |t|
      t.text :content
      t.bigint :user_id, null: false
      t.bigint :assignment_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    drop_table :subtasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.integer :priority
      t.bigint :assignment_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    drop_table :whiteboard_sessions do |t|
      t.string :title
      t.text :content
      t.bigint :project_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    drop_table :whiteboards do |t|
      t.string :title
      t.text :content
      t.bigint :project_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
