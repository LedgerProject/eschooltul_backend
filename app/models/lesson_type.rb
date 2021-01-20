class LessonType < ApplicationRecord
  has_many :lessons, dependent: :nullify
end
