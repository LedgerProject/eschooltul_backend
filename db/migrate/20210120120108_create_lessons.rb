class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.string :name
      t.text :description
      t.text :grading_method
      t.belongs_to :lesson_type, null: true, foreign_key: true
      t.belongs_to :course, null: false, foreign_key: true
      t.belongs_to :term, null: true, foreign_key: true

      t.timestamps
    end
  end
end
