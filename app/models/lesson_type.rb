class LessonType < ApplicationRecord
  has_many :lessons, dependent: :nullify

  paginates_per 6

  validates :name, presence: true
end
