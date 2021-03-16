class AddCourseToReports < ActiveRecord::Migration[6.0]
  def change
    add_reference :reports, :course, foreign_key: true
    add_column :reports, :date, :date
  end
end
