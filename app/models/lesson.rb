class Lesson < ApplicationRecord
  belongs_to :lesson_type, optional: true
  belongs_to :course
  belongs_to :term, optional: true

  paginates_per 6

  validates :lesson_type, presence: true
  validates :name, presence: true
end
