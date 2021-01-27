class Course < ApplicationRecord
  scope :grades, lambda {
    includes(:terms, :students, :lessons)
      .map do |course|
        course.as_json.merge({
                               terms: course.terms.as_json,
                               students: course.students.with_marks,
                               lessons: course.lessons.as_json
                             })
      end
  }

  scope :teacher_grades, lambda {
    where(user_id: current_user.id)
      .includes(:terms, :students, :lessons)
      .map  do |course|
        course.as_json.merge({
                               terms: course.terms.as_json,
                               students: course.students.with_marks,
                               lessons: course.lessons.as_json
                             })
      end
  }

  belongs_to :user, optional: true
  has_many :course_students, dependent: :delete_all
  has_many :students, through: :course_students
  has_many :terms, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :marks, as: :remarkable, dependent: :destroy
  paginates_per 6

  validates :subject, uniqueness: { scope: :name }
  validates :user, presence: true

  def full_name
    [name, subject].join(" ")
  end
end
