class Course < ApplicationRecord
  belongs_to :user, optional: true
  has_many :course_students, dependent: :delete_all
  has_many :students, through: :course_students
  paginates_per 6

  validates :subject, uniqueness: { scope: :name }

  def full_name
    [name, subject].join(" ")
  end
end
