class Student < ApplicationRecord
  default_scope { where(deactivated: false) }

  scope :with_marks, lambda {
    includes(:marks)
      .map do |student|
      student.as_json.merge({ marks: student.marks.as_json })
    end
  }

  paginates_per 6

  has_many :course_students, dependent: :delete_all
  has_many :courses, through: :course_students
  has_many :marks, dependent: :delete_all

  def full_name
    [name, first_surname, second_surname].join(" ")
  end

  def deactivated?
    deactivated
  end
end
