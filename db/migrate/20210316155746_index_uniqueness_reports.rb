class IndexUniquenessReports < ActiveRecord::Migration[6.0]
  def change
    remove_index :reports, :student_id
    remove_index :reports, :course_id
    add_index :reports, %i[student_id course_id date], unique: true, name: "unique_report_index"
  end
end
