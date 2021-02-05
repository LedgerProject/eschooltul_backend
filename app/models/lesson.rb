class Lesson < ApplicationRecord
  belongs_to :lesson_type, optional: true
  belongs_to :course
  belongs_to :term, optional: true
  has_many :marks, as: :remarkable, dependent: :destroy

  paginates_per 6

  validates :lesson_type, presence: true
  validates :name, presence: true
end
