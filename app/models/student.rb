class Student < ApplicationRecord
  default_scope { where(deactivated: false) }

  has_many :course_students, dependent: :delete_all
  has_many :courses, through: :course_students

  def full_name
    [name, first_surname, second_surname].join(" ")
  end
end
