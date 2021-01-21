class Term < ApplicationRecord
  belongs_to :course
  has_many :lessons, dependent: :nullify

  paginates_per 6

  validates :name, presence: true
end
