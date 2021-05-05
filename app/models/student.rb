class Student < ApplicationRecord
  default_scope { where(deactivated: false) }

  paginates_per 6

  has_many :course_students, dependent: :delete_all
  has_many :courses, through: :course_students
  has_many :marks, dependent: :delete_all
  has_many :reports, dependent: :nullify
  has_many_attached :documents, dependent: :destroy

  def full_name
    [name, first_surname, second_surname].join(" ")
  end

  def deactivated?
    deactivated
  end
end
