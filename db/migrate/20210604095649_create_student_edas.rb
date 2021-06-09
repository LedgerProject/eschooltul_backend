class CreateStudentEdas < ActiveRecord::Migration[6.0]
  def change
    create_table :student_edas do |t|
      t.string :student_code
      t.string :mode_of_study
      t.string :mode_of_delivery
      t.string :language
      t.string :email_address
      t.date :certification_date
      t.string :course_unit_type
      t.date :date
      t.string :ECTS_grading_scale_type
      t.string :national_framework_qualifications
      t.decimal :percent, precision: 3, scale: 2
      t.string :source_grade

      t.belongs_to :student, null: true, foreign_key: true
      t.timestamps
    end
  end
end
