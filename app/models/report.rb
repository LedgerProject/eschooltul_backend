class Report < ApplicationRecord
  belongs_to :student
  belongs_to :course
  validates :content_hash, uniqueness: true
  validates :student_id,
            uniqueness: { scope: %i[course_id date],
                          message: "This report is already in the database" }
end
