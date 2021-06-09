class StudentEda < ApplicationRecord
  belongs_to :student

  validate :student_code
end
