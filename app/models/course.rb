class Course < ApplicationRecord
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
