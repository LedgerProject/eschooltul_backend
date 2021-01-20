class Lesson < ApplicationRecord
  belongs_to :lesson_type, optional: true
  belongs_to :course
  belongs_to :term, optional: true

  validates :lesson_type, allow_nil: false
end
