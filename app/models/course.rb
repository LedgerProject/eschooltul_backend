class Course < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  belongs_to :user
  has_many :course_students, dependent: :delete_all
  has_many :students, through: :course_students
  has_many :terms, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :marks, as: :remarkable, dependent: :destroy
  has_many :reports, dependent: :nullify
  paginates_per 6

  validates :subject, uniqueness: { scope: :name }
  validates :user, presence: true

  def full_name
    [name, subject].join(" ")
  end
end
