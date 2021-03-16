class AddStudentToReports < ActiveRecord::Migration[6.0]
  def change
    add_reference :reports, :student, foreign_key: true
  end
end
