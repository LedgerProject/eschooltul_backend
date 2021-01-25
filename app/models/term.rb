class Term < ApplicationRecord
  belongs_to :course
  has_many :lessons, dependent: :nullify
  has_many :marks, as: :remarkable, dependent: :destroy

  paginates_per 6

  validates :name, presence: true
end
