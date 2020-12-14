class Course < ApplicationRecord
  belongs_to :user
  has_many :course_students
  has_many :students, through: :course_students

  validates :subject, uniqueness: { scope: :name }

  def full_name
    [name, subject].join(" ")
  end
end
