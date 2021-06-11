class StudentEda < ApplicationRecord
  belongs_to :student

  validates :student_code, presence: true
end
