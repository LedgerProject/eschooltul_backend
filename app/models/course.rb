class Course < ApplicationRecord
  belongs_to :user

  validates :subject, uniqueness: { scope: :name }
end
