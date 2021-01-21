class Term < ApplicationRecord
  belongs_to :course
  has_many :lessons, dependent: :nullify

  validates :name, presence: true
end
